import random


ALLOWED_CHARS = [chr(x) for x in range(ord("A"), ord("Z") + 1)] + [
    str(x) for x in range(10)
]


def possible_tans(length: int) -> int:
    return len(ALLOWED_CHARS) ** length


class Tan:
    value: str = ""

    def __init__(self, length_or_value: int | str = 5):
        """
        Initializes a new TAN with a random value or a given string.

        Parameters:
        length_or_value (int | str): The length of the TAN to generate or a string to use as the TAN value. Default is 5.

        Raises:
        TypeError: If length_or_value is not an int or str.
        """
        if isinstance(length_or_value, int):
            self.value = "".join(random.choices(ALLOWED_CHARS, k=length_or_value))
        elif isinstance(length_or_value, str):
            self.value = length_or_value.upper()
        else:
            raise TypeError(
                f"Wrong type for Tan constructor. Expected int or str, got {type(length_or_value)}"
            )

    def __eq__(self, other):
        """
        Checks if this TAN is equal to another TAN or string, ignoring case.

        Parameters:
        other (Tan or str): The other TAN or string to compare with.

        Returns:
        bool: True if the TANs or strings are equal (ignoring case), False otherwise.
        """
        if isinstance(other, Tan):
            return self.value.upper() == other.value.upper()
        elif isinstance(other, str):
            return self.value.upper() == other.upper()
        else:
            return False

    def __str__(self):
        """
        Returns the string representation of this TAN.

        Returns:
        str: The string representation of this TAN.
        """
        return self.value.upper()

    def __repr__(self):
        """
        Returns the developer-friendly string representation of this TAN.

        Returns:
        str: The developer-friendly string representation of this TAN.
        """
        return f"Tan({self.value.upper()!r})"


def uniques(n: int, length: int = 5) -> list[Tan]:
    """
    Generates a list of unique TANs.

    Parameters:
    n (int): The number of unique TANs to generate.
    length (int): The length of each generated TAN. Default is 5.

    Returns:
    list[Tan]: The list of generated unique TANs.

    Raises:
    ValueError: If n is greater than the maximum possible TANs of the given length.
    """
    if n > possible_tans(length):
        raise ValueError(
            f"Cannot generate {n} unique TANs of length {length}. Maximum possible TANs is {possible_tans(length)}."
        )
    tans = set()
    while len(tans) < n:
        tans.add(Tan(length))
    return list(tans)
