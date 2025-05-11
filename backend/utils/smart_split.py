from langchain.text_splitter import RecursiveCharacterTextSplitter

def smart_chunk(text):
  text_splitter = RecursiveCharacterTextSplitter(
      chunk_size=1000,
      chunk_overlap=200
      )
  return text_splitter.split_text(text)
