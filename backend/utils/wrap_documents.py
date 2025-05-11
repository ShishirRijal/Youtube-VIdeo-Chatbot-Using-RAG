from langchain.schema import Document

def wrap_documents(chunks):
    return [Document(page_content=chunk) for chunk in chunks]
