# import os
# from dotenv import load_dotenv
# import chromadb
# from openai import OpenAI
# from chromadb.utils import embedding_functions
# from fastapi import FastAPI, HTTPException, UploadFile, File
# from pydantic import BaseModel
# from PyPDF2 import PdfReader
# import uvicorn
#
# # instance of  the fastApi
# from fastapi import  FastAPI
#
#
#
# # app = FastAPI()
#
# # @app.get("/")
# # def hello_world():
# #     return " Hello Word"
#
# # ===================== SETUP =====================
# # Load env variables
# # load_dotenv()
# openai_key = os.getenv("OPENAI_API_KEY")
# # if not openai_key:
# #     raise ValueError("OPENAI_API_KEY environment variable is not set.")
#
# # OpenAI & Chroma setup
# openai_ef = embedding_functions.OpenAIEmbeddingFunction(
#     api_key=openai_key, model_name="text-embedding-3-small"
# )
# chroma_client = chromadb.PersistentClient(path="chroma_persistent_storage")
# collection = chroma_client.get_or_create_collection(
#     name="document_qa_collection", embedding_function=openai_ef
# )
# client = OpenAI(api_key=openai_key)
# # response = client.chat.completions.create(
# #         model="gpt-3.5-turbo",
# #         messages=[
# #             {"role": "system", "content": "You are a helpful assistant."},
# #             {
# #                 "role": "user",
# #                 "content": "What is human life expectancy in the United States?",
# #             },
# #         ],
# #     )
# # print( response.choices[0].message.content)
#
#
# # Function to load documents from a directory (txt + pdf)
# def extract_text_from_pdf(file_path, password=None):
#     pdf_reader = PdfReader(file_path)
#
#     # If encrypted, try decrypting
#     if pdf_reader.is_encrypted:
#         if password:
#             pdf_reader.decrypt(password)
#         else:
#             raise ValueError(f"PDF '{file_path}' is encrypted. Provide a password.")
#
#     text = ""
#     for page in pdf_reader.pages:
#         text += page.extract_text() or ""
#     return text
#
# def load_documents_from_directory(directory_path):
#     print("==== Loading documents from directory ====")
#     documents = []
#     for filename in os.listdir(directory_path):
#         file_path = os.path.join(directory_path, filename)
#
#         if filename.endswith(".txt"):
#             with open(file_path, "r", encoding="utf-8") as file:
#                 documents.append({"id": filename, "text": file.read()})
#
#         elif filename.endswith(".pdf"):
#             try:
#                 text = extract_text_from_pdf(file_path)  # if encrypted and no password, will error
#                 documents.append({"id": filename, "text": text})
#             except Exception as e:
#                 print(f"⚠️ Could not load {filename}: {e}")
#
#     return documents
#
#
#
# # ===================== HELPERS =====================
# def split_text(text, chunk_size=1000, chunk_overlap=20):
#     chunks, start = [], 0
#     while start < len(text):
#         end = start + chunk_size
#         chunks.append(text[start:end])
#         start = end - chunk_overlap
#     return chunks
#
# def get_openai_embedding(text: str):
#     response = client.embeddings.create(input=text, model="text-embedding-3-small")
#     return response.data[0].embedding
#
# def query_documents(question: str, n_results=2):
#     results = collection.query(query_texts=[question], n_results=n_results)
#     relevant_chunks = [doc for sublist in results["documents"] for doc in sublist]
#     return relevant_chunks
#
# # Load documents (txt + pdf)
# directory_path = "./car_manuels"   # <-- put PDFs here
# documents = load_documents_from_directory(directory_path)
#
# # Split & embed
# chunked_documents = []
# for doc in documents:
#     chunks = split_text(doc["text"])
#     for i, chunk in enumerate(chunks):
#         chunk_id = f"{doc['id']}_chunk{i+1}"
#         embedding = get_openai_embedding(chunk)
#         collection.upsert(
#             ids=[chunk_id],
#             documents=[chunk],
#             embeddings=[embedding]
#         )
#
#
# def generate_response(question: str, relevant_chunks):
#     context = "\n\n".join(relevant_chunks)
#     prompt = (
#             "You are an assistant for question-answering tasks. Use the following pieces of "
#             "retrieved context to answer the question. If you don't know the answer, say that you "
#             "don't know. Use three sentences maximum and keep the answer concise."
#             "\n\nContext:\n" + context + "\n\nQuestion:\n" + question
#     )
#     response = client.chat.completions.create(
#         model="gpt-3.5-turbo",
#         messages=[
#             {"role": "system", "content": prompt},
#             {"role": "user", "content": question},
#         ],
#     )
#     return response.choices[0].message.content
#
# # ===================== API =====================
# app = FastAPI()
#
# class QueryRequest(BaseModel):
#     question: str
#     n_results: int = 2
#
# @app.post("/query")
# def query_api(req: QueryRequest):
#     try:
#         relevant_chunks = query_documents(req.question, req.n_results)
#         if not relevant_chunks:
#             return {"answer": "I couldn't find any relevant context."}
#         answer = generate_response(req.question, relevant_chunks)
#         return {"question": req.question, "answer": answer, "context": relevant_chunks}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))
#
#
#
#
#
#
#
#
# # ===================== START SERVER =====================
# # Run with: uvicorn filename:app --reload
# if __name__ == "__main__":
#     uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
#

import os
from dotenv import load_dotenv
import chromadb
from openai import OpenAI
from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel
from PyPDF2 import PdfReader
import uvicorn
import requests


# Load env
load_dotenv()
openai_key = os.getenv("OPENAI_API_KEY")

# OpenAI client
client = OpenAI(api_key=openai_key)

# Chroma client (Koyeb-approved path)
chroma_client = chromadb.PersistentClient(path="/data/chroma")
collection = chroma_client.get_or_create_collection(name="document_qa_collection")

# FastAPI app
app = FastAPI()


# ---------------- PDF Helper ----------------
def extract_text_from_pdf(file_path):
    pdf = PdfReader(file_path)
    text = ""
    for page in pdf.pages:
        text += page.extract_text() or ""
    return text


def split_text(text, chunk_size=1000, chunk_overlap=20):
    chunks, start = [], 0
    while start < len(text):
        end = start + chunk_size
        chunks.append(text[start:end])
        start = end - chunk_overlap
    return chunks


def get_openai_embedding(text: str):
    resp = client.embeddings.create(
        input=text,
        model="text-embedding-3-small"
    )
    return resp.data[0].embedding




def download_from_backblaze(file_name):
    bucket_url = os.getenv("B2_BUCKET_URL")
    download_url = f"{bucket_url}/{file_name}"

    save_dir = "./car_manuels"
    os.makedirs(save_dir, exist_ok=True)
    save_path = f"{save_dir}/{file_name}"

    print("Downloading:", download_url)

    res = requests.get(download_url)
    if res.status_code != 200:
        print("Failed to download:", res.text)
    else:
        with open(save_path, "wb") as f:
            f.write(res.content)
        print(f"Saved to {save_path}")

# ---------------- API ROUTES ----------------

# Upload + embed PDF
@app.post("/upload_pdf")
async def upload_pdf(file: UploadFile = File(...)):
    if not file.filename.endswith(".pdf"):
        raise HTTPException(400, "Only PDF files allowed")

    file_path = f"/data/{file.filename}"

    with open(file_path, "wb") as f:
        f.write(await file.read())

    text = extract_text_from_pdf(file_path)
    chunks = split_text(text)

    for i, chunk in enumerate(chunks):
        emb = get_openai_embedding(chunk)
        chunk_id = f"{file.filename}_chunk{i}"

        collection.upsert(
            ids=[chunk_id],
            documents=[chunk],
            embeddings=[emb]
        )

    return {"status": "success", "chunks": len(chunks)}


# Query
class QueryRequest(BaseModel):
    question: str
    n_results: int = 2


@app.post("/query")
def query(req: QueryRequest):
    try:
        results = collection.query(
            query_texts=[req.question],
            n_results=req.n_results
        )
        docs = [d for sub in results["documents"] for d in sub]

        if not docs:
            return {"answer": "No relevant context found"}

        answer = generate_response(req.question, docs)
        return {"answer": answer, "context": docs}

    except Exception as e:
        raise HTTPException(500, str(e))


def generate_response(question, context_chunks):
    context = "\n\n".join(context_chunks)
    prompt = (
        "Use the following context to answer the question. "
        "Keep it short.\n\n"
        f"Context:\n{context}\n\nQuestion:\n{question}"
    )

    resp = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": prompt},
            {"role": "user", "content": question},
        ],
    )
    return resp.choices[0].message.content


# Start local server
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
