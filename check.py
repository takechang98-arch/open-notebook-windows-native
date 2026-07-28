import sys
from pathlib import Path

# プロジェクトルートを確実に参照できるように設定
base_dir = Path(__file__).resolve().parent
if str(base_dir) not in sys.path:
    sys.path.insert(0, str(base_dir))

import asyncio
try:
    from open_notebook.database.surreal import get_db
except ImportError:
    # パッケージとして認識させるためのフォールバック
    import site
    site.addsitedir(str(base_dir))
    from open_notebook.database.surreal import get_db

async def main():
    try:
        async with get_db() as db:
            res = await db.query("SELECT id, name, status, created_at FROM command ORDER BY created_at DESC LIMIT 5;")
            print("\n=== DB Query Result ===")
            print(res)
            print("=======================\n")
    except Exception as e:
        print(f"\n[DB Connection/Query Error]: {e}\n")

if __name__ == "__main__":
    asyncio.run(main())