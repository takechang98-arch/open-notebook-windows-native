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

### 💻 Confirmed Working Environment (Tested on Low-End / Legacy Hardware)

This project has been verified to run stably on entry-level / legacy hardware:

| Component | Verified Specification |
| :--- | :--- |
| **CPU** | Intel Core i3-1005G1 @ 1.20GHz |
| **RAM** | 8.00 GB (7.74 GB usable) |
| **GPU** | Intel UHD Graphics (Integrated / Shared Memory) |
| **OS** | Windows 11 / 10 64-bit |
| **LLM Model** | `qwen2.5:3b` / `nomic-embed-text` (via Ollama) |

> 💡 **Note on Low-Resource Optimization:** > By disabling memory-intensive OCR libraries (`docling_ocr`) and bypassing Docker virtualization, this setup achieves reliable performance even on dual-core systems with 8GB RAM.

---

## 🚀 Quick Start Guide

### 1. Environment Setup

Clone this repository and create your local environment file:

```cmd
cp .env.example .env