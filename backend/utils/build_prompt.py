from langchain.prompts import PromptTemplate


def get_rag_prompt():
    return PromptTemplate.from_template("""
    You are a smart AI assistant designed to answer questions based ONLY on the provided context and your response should only include the answer and nothing else.
    Carefully read the following context derived from a YouTube transcript:

    Context:
    {context}

    Answer the user's question using ONLY the information available in the context.
    Do NOT use any prior knowledge.
    If the context does not contain enough information to answer the question,
    state clearly that you cannot find the answer in the provided information.
    Avoid making assumptions or generating information that is not in the context.

    Question: {question}

    Answer:
    """)