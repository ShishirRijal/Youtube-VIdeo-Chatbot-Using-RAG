from langchain.schema.runnable import RunnablePassthrough
from langchain.schema.output_parser import StrOutputParser
from langchain.schema.runnable import RunnableParallel
from langchain_core.runnables import RunnableLambda


def extract_answer_only(output: str) -> str:
    if "Answer:" in output:
        return output.split("Answer:")[-1].strip()
    return output.strip()


def build_rag_chain(llm, retriever, prompt):
    parser = StrOutputParser()
    parallel_chain = RunnableParallel({
        "context": retriever, 
        "question": RunnablePassthrough()
    })
    chain = parallel_chain | prompt | llm | RunnableLambda(extract_answer_only)
    return chain


if __name__ == "__main__":
    from utils.build_llm import get_llm
    from utils.load_retrivers import load_retriever
    from utils.build_prompt import get_rag_prompt

    # Load the LLM and retriever
    llm = get_llm()
    retriever = load_retriever()
    prompt = get_rag_prompt()

    # Build the RAG chain
    chain = build_rag_chain(llm, retriever, prompt)\

    # Test the chain with a sample question
    question = "What is the main topic of the video?"
    response = chain.invoke("What is RAG?")
    print(response)
    