import asyncio
import traceback
from open_notebook.database.async_migrate import AsyncMigrationManager

async def main():
    manager = AsyncMigrationManager()
    try:
        print('START')
        await manager.run_migration_up()
        print('MIGRATIONS_OK')
    except Exception as exc:
        print('MIGRATIONS_FAILED')
        traceback.print_exc()
        raise

asyncio.run(main())
