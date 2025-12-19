"""Mouse controller using pyautogui."""
import pyautogui

# Disable fail-safe (moving mouse to corner won't raise exception)
pyautogui.FAILSAFE = False
# Disable pause between actions for responsiveness
pyautogui.PAUSE = 0


def move_relative(dx: int, dy: int) -> None:
    """Move mouse by relative offset."""
    pyautogui.moveRel(dx, dy, _pause=False)


def click(button: str = "left") -> None:
    """Perform mouse click."""
    pyautogui.click(button=button, _pause=False)


def scroll(dy: int) -> None:
    """Scroll mouse wheel. Positive = up, negative = down."""
    pyautogui.scroll(dy, _pause=False)


def drag_start() -> None:
    """Start drag operation (mouse down)."""
    pyautogui.mouseDown(_pause=False)


def drag_end() -> None:
    """End drag operation (mouse up)."""
    pyautogui.mouseUp(_pause=False)
