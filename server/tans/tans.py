import random


ALLOWED_CHARS = [chr(x) for x in range(ord("A"), ord("Z") + 1)] + [
    str(x) for x in range(10)
]


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
            self.value = length_or_value
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
            return self.value.lower() == other.value.lower()
        elif isinstance(other, str):
            return self.value.lower() == other.lower()
        else:
            return False

    def __str__(self):
        """
        Returns the string representation of this TAN.

        Returns:
        str: The string representation of this TAN.
        """
        return self.value

    def __repr__(self):
        """
        Returns the developer-friendly string representation of this TAN.

        Returns:
        str: The developer-friendly string representation of this TAN.
        """
        return f"Tan({self.value!r})"


def uniques(n: int, length: int = 5) -> list[Tan]:
    """
    Generates a list of unique TANs.

    Parameters:
    n (int): The number of unique TANs to generate.
    length (int): The length of each generated TAN. Default is 5.

    Returns:
    list[Tan]: The list of generated unique TANs.
    """
    tans = []
    while len(tans) < n:
        candidate = Tan(length)
        # Make sure that the tans are unique
        if candidate not in tans:
            tans.append(candidate)
    return tans
