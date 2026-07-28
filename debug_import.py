import traceback
try:
    import api.main
    print('IMPORT_OK')
except Exception as exc:
    print('IMPORT_FAILED')
    traceback.print_exc()
    raise
