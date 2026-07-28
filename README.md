# Open-Notebook Windows Native Setup (No Docker)

A lightweight, standalone Windows-native setup for running **Open-Notebook** locally with **Ollama (Qwen 2.5 / nomic-embed-text)** and **SurrealDB**, completely bypassing Docker requirements.

---

## 📌 Features & Architecture

* **Docker-Free Execution:** Native multi-process management on Windows 11.
* **Database Persistence:** SurrealDB configured with `rocksdb` engine to prevent data loss on restart.
* **Memory & Performance Optimization:** Disabled heavy OCR dependencies (`docling_ocr`) to prevent UI freezes on mid-tier machines.
* **Character Encoding Protection:** Robust UTF-8 with automatic `CP932` / `Shift-JIS` fallback for Japanese text processing.
* **One-Click Orchestration:** Includes a batch script (`start_notebook.bat`) to manage background workers and environment variables seamlessly.

---

## 🛠️ Environment Requirements

| Component | Version / Specification |
| :--- | :--- |
| **OS** | Windows 11 / 10 |
| **Python** | 3.13 / 3.12 |
| **Database** | SurrealDB (Windows Binary) |
| **Local LLM Runtime** | Ollama (`qwen2.5:3b`, `nomic-embed-text`) |
| **Frontend** | Node.js / Next.js |

---

## 🚀 Quick Start Guide

### 1. Environment Setup

Clone this repository and create your local environment file:

```cmd
cp .env.example .env