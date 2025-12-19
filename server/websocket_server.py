"""WebSocket server for receiving mouse commands."""
import asyncio
import json
import socket
from typing import Callable, Optional

import websockets
from websockets.server import WebSocketServerProtocol


class MouseWebSocketServer:
    """WebSocket server that receives mouse commands."""

    def __init__(self, host: str = "0.0.0.0", port: int = 8765):
        self.host = host
        self.port = port
        self.on_message: Optional[Callable[[dict], None]] = None
        self.on_connect: Optional[Callable[[], None]] = None
        self.on_disconnect: Optional[Callable[[], None]] = None
        self._server = None
        self._connected_clients: set = set()

    def get_local_ip(self) -> str:
        """Get local IP address for display."""
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            s.close()
            return ip
        except Exception:
            return "127.0.0.1"

    async def _handle_client(self, websocket: WebSocketServerProtocol) -> None:
        """Handle a connected client."""
        self._connected_clients.add(websocket)
        print(f"Client connected: {websocket.remote_address}")

        if self.on_connect:
            self.on_connect()

        try:
            async for message in websocket:
                try:
                    data = json.loads(message)
                    if self.on_message:
                        self.on_message(data)
                except json.JSONDecodeError:
                    print(f"Invalid JSON: {message}")
        except websockets.exceptions.ConnectionClosed:
            pass
        finally:
            self._connected_clients.discard(websocket)
            print(f"Client disconnected: {websocket.remote_address}")
            if self.on_disconnect:
                self.on_disconnect()

    async def start(self) -> None:
        """Start the WebSocket server."""
        self._server = await websockets.serve(
            self._handle_client,
            self.host,
            self.port,
            ping_interval=20,
            ping_timeout=60
        )
        print(f"WebSocket server started on {self.host}:{self.port}")

    async def stop(self) -> None:
        """Stop the WebSocket server."""
        if self._server:
            self._server.close()
            await self._server.wait_closed()

    def run(self) -> None:
        """Run the server (blocking)."""
        asyncio.run(self._run_forever())

    async def _run_forever(self) -> None:
        """Run server forever."""
        await self.start()
        await asyncio.Future()  # Run forever
