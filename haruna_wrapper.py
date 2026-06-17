#!/usr/bin/env python3
import sys
import json
import struct
import subprocess

# Lê uma mensagem (comprimento de 4 bytes seguido pelo JSON) da entrada padrão
def get_message():
    raw_length = sys.stdin.buffer.read(4)
    if len(raw_length) == 0:
        sys.exit(0)
    message_length = struct.unpack('@I', raw_length)[0]
    message = sys.stdin.buffer.read(message_length).decode('utf-8')
    return json.loads(message)

# Envia uma mensagem (comprimento de 4 bytes seguido pelo JSON) de volta ao Firefox
def send_message(message_content):
    encoded_content = json.dumps(message_content).encode('utf-8')
    sys.stdout.buffer.write(struct.pack('@I', len(encoded_content)))
    sys.stdout.buffer.write(encoded_content)
    sys.stdout.buffer.flush()

if __name__ == '__main__':
    while True:
        try:
            message = get_message()
            url = message.get('url')
            if url:
                # Inicia o Haruna enviando a saída para DEVNULL para não travar a comunicação
                subprocess.Popen(['haruna', url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                send_message({"status": "Success", "opened_url": url})
            else:
                send_message({"status": "Error", "message": "Nenhuma URL fornecida"})
        except Exception as e:
            send_message({"status": "Error", "message": str(e)})
            sys.exit(1)
