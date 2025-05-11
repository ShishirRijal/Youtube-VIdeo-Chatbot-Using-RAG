from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from utils.build_llm import get_llm
from utils.load_retrivers import load_retriever
from utils.build_prompt import get_rag_prompt
from utils.fetch_transcript import fetchTranscript
from utils.smart_split import smart_chunk
from utils.wrap_documents import wrap_documents
from ingest import build_faiss_index
from rag_pipeline import build_rag_chain
import logging # Recommended for logging

app = FastAPI()

# Initialize components that don't depend on the index
llm = get_llm()
rag_prompt = get_rag_prompt()
chain = None  # Will be initialized by try_load_chain

logger = logging.getLogger("uvicorn") # For better logging

def try_load_chain():
    global chain
    retriever = load_retriever()
    if retriever:
        try:
            chain = build_rag_chain(llm, retriever, rag_prompt)
            logger.info("RAG chain initialized successfully.")
            return True
        except Exception as e:
            logger.error(f"Failed to build RAG chain: {e}")
            chain = None
            return False
    else:
        logger.warning("Retriever not loaded (index likely missing). RAG chain not initialized.")
        chain = None
        return False

@app.on_event("startup")
async def startup_event():
    logger.info("Application startup: attempting to load RAG chain.")
    try_load_chain()

class QueryRequest(BaseModel):
    question: str

class VideoRequest(BaseModel):
    video_id: str

@app.get("/")
async def root():
    return {"message": "Welcome to the RAG API!"}

@app.post("/index-youtube")
async def index_youtube_video(request: VideoRequest):
    try:
        transcript = fetchTranscript(request.video_id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    chunks = smart_chunk(transcript)
    # docs = wrap_documents(chunks) # docs variable is not used by build_faiss_index

    build_faiss_index(chunks) # This creates/updates faiss_index

    logger.info(f"Successfully indexed video ID: {request.video_id}. Attempting to reload RAG chain.")
    if try_load_chain():
        return {"message": f"Indexed transcript for video ID: {request.video_id}. RAG chain reloaded."}
    else:
        return {"message": f"Indexed transcript for video ID: {request.video_id}, but RAG chain could not be reloaded (index issue or other error)."}

@app.post("/query")
async def query_rag(request: QueryRequest):
    if chain is None:
        logger.warning("Query received but RAG chain is not initialized.")
        # Optionally, try to load it again, or just inform the user.
        # if not try_load_chain(): # Uncomment to attempt lazy load on first query
        raise HTTPException(status_code=503, detail="RAG chain is not available. Please index a video first or wait for initialization.")

    try:
        answer = chain.invoke(request.question)
        return {"answer": answer}
    except Exception as e:
        logger.error(f"Error during RAG query invocation: {e}")
        raise HTTPException(status_code=500, detail=f"Error processing query: {str(e)}")