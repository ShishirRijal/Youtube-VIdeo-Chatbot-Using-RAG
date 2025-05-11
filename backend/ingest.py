from langchain.vectorstores import FAISS
from langchain.embeddings import HuggingFaceEmbeddings
from utils.wrap_documents import wrap_documents

def build_faiss_index(chunks, model_name="BAAI/bge-small-en-v1.5", index_path="faiss_index"):
    embedding = HuggingFaceEmbeddings(model_name=model_name, encode_kwargs={"normalize_embeddings": True})
    docs = wrap_documents(chunks)
    db = FAISS.from_documents(docs, embedding)
    db.save_local(index_path)
    print(f"Index saved to: {index_path}")
