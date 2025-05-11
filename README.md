
<h1 align="center">🎥🤖 YouTube Video Chatbot using RAG</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Backend-FastAPI-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Frontend-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/LLM-LLaMA3--8B--Instruct-purple?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Embeddings-BAAI--bge--small--en--v1.5-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/VectorDB-FAISS-success?style=for-the-badge" />
</p>

<p align="center">
  <b>A futuristic chatbot that lets you talk to any YouTube video using RAG (Retrieval-Augmented Generation).</b><br />
  Built with cutting-edge tools, optimized for mobile, and designed while learning how RAG systems work.
</p>

---

## 🚀 Overview

Have you ever wanted to **ask questions to a YouTube video**? Now you can.

This project is a **YouTube Video Question Answering Chatbot** powered by:
- **Automatic transcript extraction**
- **Embedding-based retrieval**
- **LLaMA3-8B-Instruct for smart answers**
- A mobile-first **Flutter app interface**

---

## 🧠 System Architecture

> A full pipeline from `YouTube video ID` ➜ `Transcript` ➜ `Chunking & Embedding` ➜ `FAISS Indexing` ➜ `LLM-generated answers`


![YoutubeChatBot](https://github.com/user-attachments/assets/bd506b33-560a-4dc7-acd6-008dce70b773)

---

## 🛠 Tech Stack

| Layer       | Tech                                   |
|------------|----------------------------------------|
| 🧠 LLM      | [LLaMA-3-8B-Instruct](https://huggingface.co/meta-llama) |
| 📚 Embedding | `BAAI/bge-small-en-v1.5` with `HuggingFaceEmbeddings` |
| 🧲 VectorDB | FAISS                                 |
| 🛰 Backend  | FastAPI + LangChain                   |
| 📱 Frontend | Flutter                               |

---

## 🧪 Features

- 🔍 Ask any question about a YouTube video
- 🎯 Chunk and embed transcripts on the fly
- ⚡ Fast, streaming-ready inference (RAG-based)
- 🧩 Extensible architecture (LLM agnostic)
- 📦 Future-ready vector store (FAISS)

---

## 🧩 API Endpoints (Backend - FastAPI)

| Method | Endpoint        | Description                          |
|--------|-----------------|--------------------------------------|
| POST   | `/index-youtube` | Provide a video ID and index it     |
| POST   | `/query`          | Ask questions about indexed content  |

---

# App Snaps

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/3b9523cb-91b7-4120-b7bf-c0b77177caa3" width="250px" alt="App Screenshot 1"/>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/6ee2b946-6861-4e39-95f2-16af8ebfe997" width="250px" alt="App Screenshot 2"/>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/3d607b10-6d1f-4584-ad5b-f82f2213eee1" width="250px" alt="App Screenshot 3"/>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/edec9a77-e570-4299-948a-b69029db3103" width="250px" alt="App Screenshot 4"/>
    </td>
    <td align="center" colspan="2">
      <img src="https://github.com/user-attachments/assets/0423ae2c-a65b-4937-99fd-38eb1e32f872" width="250px" alt="App Screenshot 5"/>
    </td>
  </tr>

</table>


---

## 📦 Getting Started

### Backend Setup

```bash
git clone https://github.com/ShishirRijal/Youtube-VIdeo-Chatbot-Using-RAG
cd Youtube-VIdeo-Chatbot-Using-RAG/backend

# Install dependencies
pip install -r requirements.txt

# Run the FastAPI server
uvicorn main:app --reload
````

Make sure you have models downloaded via `transformers` or hosted on your server.

---

### Frontend Setup (Flutter)

```bash
cd ../frontend
flutter pub get
flutter run
```

Configure your API endpoint in the mobile app to point to your FastAPI server.

---

## 🤖 Prompt Template

```text
Use the context to answer the question.
Context:
{context}

Question: {question}
```

---

## 📄 License

This project is licensed under the **MIT License**.

