# Open-Notebook Windows Native Setup (No Docker)

A lightweight, standalone Windows-native setup for running Open-Notebook locally with Ollama (Qwen 2.5 / nomic-embed-text) and SurrealDB, completely bypassing Docker requirements.

## 📌 Features & Architecture

- **Docker-Free Execution:** Native multi-process management on Windows 11/10.
- **Database Persistence:** SurrealDB configured with `rocksdb` engine to prevent data loss on restart.
- **Memory & Performance Optimization:** Disabled heavy OCR dependencies (`docling_ocr`) to prevent UI freezes on mid-tier machines.
- **Character Encoding Protection:** Robust UTF-8 with automatic CP932 / Shift-JIS fallback for Japanese text processing.
- **One-Click Orchestration:** Includes a batch script (`start_notebook.bat`) to manage background workers and environment variables seamlessly.

## 💻 Confirmed Working Environment (Tested on Low-End / Legacy Hardware)

This project has been verified to run stably on entry-level / legacy hardware:

| Component | Verified Specification |
| :--- | :--- |
| **CPU** | Intel Core i3-1005G1 @ 1.20GHz |
| **RAM** | 8.00 GB (7.74 GB usable) |
| **GPU** | Intel UHD Graphics (Integrated / Shared Memory) |
| **OS** | Windows 11 / 10 64-bit |
| **LLM Model** | `qwen2.5:3b` / `nomic-embed-text` (via Ollama) |

> 💡 **Note on Low-Resource Optimization & Important Usage Tip:** > By disabling memory-intensive OCR libraries (`docling_ocr`) and bypassing Docker virtualization, this setup runs on dual-core systems with 8GB RAM.
> 
> **Performance Tip:** > On low-spec machines, embedding generation and transformations running simultaneously can cause high CPU load (taking ~5 minutes even for a small text file). To ensure smooth processing when uploading documents, **it is recommended to skip background embedding generation during file upload** and process embeddings separately if needed.
> 
> *(Note: Response times for simple queries can currently take a few minutes on this specs. Optimization strategies for faster query processing are actively being explored.)*

## 🛠️ Environment Requirements

| Component | Version / Specification |
| :--- | :--- |
| **OS** | Windows 11 / 10 |
| **Python** | 3.12+ |
| **Database** | SurrealDB (Windows Binary) |
| **Local LLM Runtime** | Ollama (`qwen2.5:3b`, `nomic-embed-text`) |
| **Frontend** | Node.js / Next.js |

## 🚀 Quick Start Guide

### Prerequisites
Before running the setup, ensure you have the following installed on your system:
* **Python 3.12+**
* **Node.js** (v18+)
* **Ollama** (Running locally with `qwen2.5:3b` and `nomic-embed-text`)
* **SurrealDB** (Download `surreal.exe` for Windows and place it in the project root or system PATH)

### 1. Environment Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/takechang98-arch/open-notebook-windows-native.git
   cd open-notebook-windows-native
   ```

2. **Create virtual environment:**
   ```powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   ```

3. **Install Python dependencies:**
   **💡 Note: Open the generated .env file and set your API keys (e.g., OPENAI_API_KEY, GEMINI_API_KEY) and database credentials before starting the application.**
   ```powershell
   pip install uv
   uv pip install -e .
   ```

4. **Install Frontend dependencies:**
   ```PowerShell
   cd frontend
   npm install
   cd ..
   ```

5. **Configure environment variables:**
   ```PowerShell
   copy .env.example .env
   ```

6. **Launching the Application**
   **Run the included batch script to automatically start SurrealDB, Ollama worker processes, backend services, and the Web UI:**
   ```DOS
   start_notebook.bat
   ```