from pprint import pprint

# Import words
with open("/etc/dictionaries-common/words", "r") as f:
    all_words = set(line.rstrip() for line in f.readlines())

# Get valid words
words = set(word.lower() for word in all_words if word.isalpha() and len(word) == 5)

invalid_alpha = set()
required_alpha = set()
unknown_alpha = set()


def valid(word):
    word = list(word)
    if invalid_alpha.intersection(word):
        return False
    for c, i in required_alpha:
        if word[i] != c:
            return False
    for c, i in unknown_alpha:
        if word[i] == c:
            return False
        if c not in word:
            return False

    return True


# Prompt user for words until exit requested
usr_input = True
while usr_input:
    usr_input = input("Enter word and status: ")
    prompt = usr_input.split(" ")
    if len(prompt) != 2:
        print("Invalid format")
        continue

    word, status = prompt
    if len(word) != 5 or len(status) != 5 or not word.isalpha():
        print("Invalid format")
        continue

    for i, symbol in enumerate(status):
        if symbol == "_":
            invalid_alpha.add(word[i])
        if symbol == "+":
            required_alpha.add((word[i], i))
        if symbol == "?":
            unknown_alpha.add((word[i], i))

    words = set(w for w in words if valid(w))
    pprint(words)
    pprint([w for w in words if len(set(w)) == 5])
