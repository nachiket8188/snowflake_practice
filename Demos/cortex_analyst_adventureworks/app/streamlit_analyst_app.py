"""
AdventureWorks Sales Analytics - Cortex Analyst Demo
====================================================
Interactive Streamlit application for natural language querying
over the AdventureWorks sales dataset using Snowflake Cortex Analyst.

Deploy this app in Snowsight: Streamlit > + Streamlit App
"""

import json
from typing import Any, Dict, List, Optional

import pandas as pd
import streamlit as st

import _snowflake
from snowflake.snowpark.context import get_active_session

DATABASE = "ADVENTUREWORKS"
SCHEMA = "PUBLIC"
STAGE = "CORTEX_ANALYST_STAGE"
SEMANTIC_MODEL_FILE = "adventureworks_sales.yaml"
SEMANTIC_MODEL_PATH = f"@{DATABASE}.{SCHEMA}.{STAGE}/{SEMANTIC_MODEL_FILE}"


def get_session():
    """Get the active Snowflake session."""
    return get_active_session()


def send_analyst_message(messages: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Send a message to Cortex Analyst and return the response.
    
    Args:
        messages: List of message dictionaries with role and content
        
    Returns:
        Response dictionary from Cortex Analyst
    """
    request_body = {
        "messages": messages,
        "semantic_model_file": SEMANTIC_MODEL_PATH,
    }
    
    response = _snowflake.send_snow_api_request(
        "POST",
        "/api/v2/cortex/analyst/message",
        {},
        {},
        request_body,
        {},
        30000,
    )
    
    if response["status"] < 400:
        return json.loads(response["content"])
    else:
        raise Exception(f"Cortex Analyst error: {response['content']}")


def process_analyst_response(response: Dict[str, Any]) -> None:
    """Process and display the Cortex Analyst response."""
    content = response.get("message", {}).get("content", [])
    
    for item in content:
        item_type = item.get("type")
        
        if item_type == "text":
            st.markdown(item.get("text", ""))
            
        elif item_type == "sql":
            sql_statement = item.get("statement", "")
            
            with st.expander("📝 Generated SQL", expanded=False):
                st.code(sql_statement, language="sql")
            
            try:
                session = get_session()
                df = session.sql(sql_statement).to_pandas()
                
                if len(df) == 0:
                    st.info("Query returned no results.")
                elif len(df) == 1 and len(df.columns) == 1:
                    st.metric(label=df.columns[0], value=f"{df.iloc[0, 0]:,.2f}" if isinstance(df.iloc[0, 0], (int, float)) else df.iloc[0, 0])
                else:
                    tab_data, tab_chart = st.tabs(["📊 Data", "📈 Chart"])
                    
                    with tab_data:
                        st.dataframe(df, use_container_width=True)
                    
                    with tab_chart:
                        if len(df.columns) >= 2 and len(df) > 1:
                            numeric_cols = df.select_dtypes(include=['number']).columns.tolist()
                            if numeric_cols:
                                chart_df = df.set_index(df.columns[0])
                                st.bar_chart(chart_df[numeric_cols])
                        else:
                            st.info("Chart requires at least 2 columns and multiple rows.")
                            
            except Exception as e:
                st.error(f"Error executing query: {str(e)}")
                
        elif item_type == "suggestions":
            suggestions = item.get("suggestions", [])
            if suggestions:
                st.markdown("**💡 Suggested follow-up questions:**")
                for suggestion in suggestions:
                    if st.button(f"→ {suggestion}", key=f"suggestion_{hash(suggestion)}"):
                        st.session_state.pending_question = suggestion
                        st.rerun()


def display_chat_history():
    """Display the conversation history."""
    for i, message in enumerate(st.session_state.messages):
        role = message.get("role", "user")
        content = message.get("content", [])
        
        if role == "user":
            with st.chat_message("user"):
                for item in content:
                    if item.get("type") == "text":
                        st.markdown(item.get("text", ""))
        else:
            with st.chat_message("assistant"):
                for item in content:
                    item_type = item.get("type")
                    if item_type == "text":
                        st.markdown(item.get("text", ""))
                    elif item_type == "sql":
                        with st.expander("📝 SQL Query", expanded=False):
                            st.code(item.get("statement", ""), language="sql")


def main():
    st.set_page_config(
        page_title="AdventureWorks Sales Analytics",
        page_icon="🚴",
        layout="wide",
    )
    
    st.title("🚴 AdventureWorks Sales Analytics")
    st.markdown("*Powered by Snowflake Cortex Analyst*")
    
    with st.sidebar:
        st.header("📊 About This Demo")
        st.markdown("""
        Ask questions about AdventureWorks sales data in natural language.
        
        **Data Available:**
        - 31,465 orders
        - 121,317 line items
        - ~$109M total revenue
        - May 2011 - June 2014
        
        **Tables Connected:**
        - Sales Orders & Details
        - Products & Categories
        - Customers & Persons
        - Sales Territories
        - Sales Representatives
        """)
        
        st.divider()
        
        st.subheader("💡 Example Questions")
        example_questions = [
            "What is the total revenue?",
            "Show monthly revenue trend",
            "Top 10 products by revenue",
            "Revenue by product category",
            "Compare online vs offline sales",
            "Who are the top sales reps?",
            "Revenue by territory",
            "Average order value by year",
        ]
        
        for question in example_questions:
            if st.button(question, key=f"example_{hash(question)}", use_container_width=True):
                st.session_state.pending_question = question
                st.rerun()
        
        st.divider()
        
        if st.button("🔄 Reset Conversation", use_container_width=True):
            st.session_state.messages = []
            st.session_state.pending_question = None
            st.rerun()
        
        st.divider()
        st.caption(f"Semantic Model: `{SEMANTIC_MODEL_FILE}`")
    
    if "messages" not in st.session_state:
        st.session_state.messages = []
    if "pending_question" not in st.session_state:
        st.session_state.pending_question = None
    
    for message in st.session_state.messages:
        role = message.get("role", "user")
        content = message.get("content", [])
        
        with st.chat_message("user" if role == "user" else "assistant"):
            if role == "user":
                for item in content:
                    if item.get("type") == "text":
                        st.markdown(item.get("text", ""))
            else:
                process_analyst_response({"message": message})
    
    user_input = st.chat_input("Ask a question about sales data...")
    
    question = st.session_state.pending_question or user_input
    if st.session_state.pending_question:
        st.session_state.pending_question = None
    
    if question:
        user_message = {
            "role": "user",
            "content": [{"type": "text", "text": question}]
        }
        st.session_state.messages.append(user_message)
        
        with st.chat_message("user"):
            st.markdown(question)
        
        with st.chat_message("assistant"):
            with st.spinner("Analyzing your question..."):
                try:
                    response = send_analyst_message(st.session_state.messages)
                    
                    assistant_message = response.get("message", {})
                    st.session_state.messages.append(assistant_message)
                    
                    process_analyst_response(response)
                    
                except Exception as e:
                    st.error(f"Error: {str(e)}")


if __name__ == "__main__":
    main()
