# from langchain_community.llms import HuggingFaceHub 
# import os
# from dotenv import load_dotenv

# load_dotenv()
# HUGGINGFACEHUB_API_TOKEN = os.getenv("HUGGINGFACEHUB_API_TOKEN")

# def get_llm(model_repo_id="meta-llama/Llama-3.1-8B-Instruct"):

#     llm = HuggingFaceHub(
#         repo_id=model_repo_id,
#         model_kwargs={"temperature": 0.3, "max_new_tokens": 512},
#     )
#     return llm


import os
from dotenv import load_dotenv
from langchain_huggingface import HuggingFaceEndpoint # Ensure this import is correct

load_dotenv()
HUGGINGFACEHUB_API_TOKEN = os.getenv("HUGGINGFACEHUB_API_TOKEN")

def get_llm(repo_id="meta-llama/Llama-3.1-8B-Instruct", temperature=0.7, max_new_tokens=1024):
    if not HUGGINGFACEHUB_API_TOKEN:
        raise ValueError("HUGGINGFACEHUB_API_TOKEN not found in environment variables. Please set it in your .env file.")

    llm = HuggingFaceEndpoint(
        repo_id=repo_id,
        huggingfacehub_api_token=HUGGINGFACEHUB_API_TOKEN,
        provider="hf-inference",
        temperature=temperature,
        max_new_tokens=max_new_tokens
    )
    return llm