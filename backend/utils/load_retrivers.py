import os
from langchain_community.vectorstores import FAISS 
from langchain_huggingface import HuggingFaceEmbeddings 

INDEX_DIR = "faiss_index"
# FAISS.load_local expects both index.faiss and index.pkl in this directory.
# We'll check for the directory and one of its key files.
INDEX_MARKER_FILE = os.path.join(INDEX_DIR, "index.faiss")

def load_retriever():
    if not os.path.exists(INDEX_MARKER_FILE):
        print(f"Warning: FAISS index file {INDEX_MARKER_FILE} not found. Cannot load retriever.")
        return None

    embedding_model_name = "all-MiniLM-L6-v2"
    embedding = HuggingFaceEmbeddings(
        model_name=embedding_model_name,
        encode_kwargs={"normalize_embeddings": True}
    )
    try:
        db = FAISS.load_local(INDEX_DIR, embedding, allow_dangerous_deserialization=True)
        return db.as_retriever()
    except Exception as e:
        print(f"Error loading FAISS index from {INDEX_DIR}: {e}. Returning None.")
        return None