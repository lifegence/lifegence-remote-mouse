#!/usr/bin/env python3
"""Remote Mouse Server - Main entry point with GUI."""
import sys
import os
import threading
import io
import qrcode
from PIL import Image, ImageTk

try:
    import tkinter as tk
    from tkinter import ttk
    HAS_GUI = True
except ImportError:
    HAS_GUI = False

from websocket_server import MouseWebSocketServer
from mouse_controller import move_relative, click, scroll


class ServerGUI:
    """GUI window for the server."""

    def __init__(self, ip: str, port: int):
        self.ip = ip
        self.port = port
        self.url = f"ws://{ip}:{port}"
        self.root = None
        self.status_label = None

    def create_qr_image(self, size: int = 200) -> ImageTk.PhotoImage:
        """Create QR code image."""
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=2
        )
        qr.add_data(self.url)
        qr.make(fit=True)
        img = qr.make_image(fill_color="black", back_color="white")
        img = img.resize((size, size), Image.Resampling.LANCZOS)
        return ImageTk.PhotoImage(img)

    def update_status(self, connected: bool) -> None:
        """Update connection status."""
        if self.status_label and self.root:
            def update():
                if connected:
                    self.status_label.config(
                        text="Connected",
                        foreground="green"
                    )
                else:
                    self.status_label.config(
                        text="Waiting for connection...",
                        foreground="orange"
                    )
            self.root.after(0, update)

    def run(self) -> None:
        """Run the GUI."""
        self.root = tk.Tk()
        self.root.title("Lifegence Remote Mouse Server")
        self.root.resizable(False, False)
        self.root.attributes('-topmost', True)

        # Set window icon
        icon_path = os.path.join(os.path.dirname(__file__), "icon.ico")
        if os.path.exists(icon_path):
            self.root.iconbitmap(icon_path)

        # Main frame
        main_frame = ttk.Frame(self.root, padding=20)
        main_frame.pack()

        # Title
        title = ttk.Label(
            main_frame,
            text="Lifegence Remote Mouse",
            font=("Segoe UI", 16, "bold")
        )
        title.pack(pady=(0, 15))

        # QR Code
        qr_image = self.create_qr_image(180)
        qr_label = ttk.Label(main_frame, image=qr_image)
        qr_label.image = qr_image  # Keep reference
        qr_label.pack(pady=10)

        # Connection info
        info_frame = ttk.Frame(main_frame)
        info_frame.pack(pady=10)

        ttk.Label(
            info_frame,
            text="Scan QR code or enter:",
            font=("Segoe UI", 10)
        ).pack()

        ip_text = f"{self.ip}:{self.port}"
        ip_label = ttk.Label(
            info_frame,
            text=ip_text,
            font=("Consolas", 14, "bold"),
            foreground="blue"
        )
        ip_label.pack(pady=5)

        # Status
        self.status_label = ttk.Label(
            main_frame,
            text="Waiting for connection...",
            font=("Segoe UI", 10),
            foreground="orange"
        )
        self.status_label.pack(pady=10)

        # Exit button
        exit_btn = ttk.Button(
            main_frame,
            text="Stop Server",
            command=self.root.quit
        )
        exit_btn.pack(pady=10)

        # Center window on screen
        self.root.update_idletasks()
        w = self.root.winfo_width()
        h = self.root.winfo_height()
        x = (self.root.winfo_screenwidth() // 2) - (w // 2)
        y = (self.root.winfo_screenheight() // 2) - (h // 2)
        self.root.geometry(f"+{x}+{y}")

        self.root.mainloop()


def handle_message(data: dict) -> None:
    """Handle incoming mouse command."""
    msg_type = data.get("type")

    if msg_type == "move":
        dx = data.get("dx", 0)
        dy = data.get("dy", 0)
        move_relative(dx, dy)

    elif msg_type == "click":
        button = data.get("button", "left")
        click(button)

    elif msg_type == "scroll":
        dy = data.get("dy", 0)
        scroll(dy)


def main() -> None:
    """Main entry point."""
    port = 8765

    server = MouseWebSocketServer(port=port)
    server.on_message = handle_message

    ip = server.get_local_ip()

    if HAS_GUI:
        # GUI mode
        gui = ServerGUI(ip, port)

        server.on_connect = lambda: gui.update_status(True)
        server.on_disconnect = lambda: gui.update_status(False)

        # Start server in background thread
        server_thread = threading.Thread(target=server.run, daemon=True)
        server_thread.start()

        # Run GUI in main thread
        gui.run()
    else:
        # Console mode fallback
        print(f"Remote Mouse Server")
        print(f"IP: {ip}:{port}")
        print("Waiting for connection...")

        server.on_connect = lambda: print(">>> Connected!")
        server.on_disconnect = lambda: print(">>> Disconnected")

        try:
            server.run()
        except KeyboardInterrupt:
            print("\nServer stopped.")
            sys.exit(0)


if __name__ == "__main__":
    main()
