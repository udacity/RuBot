
parts_of_speech1  = ["PLACE", "PERSON", "PLURALNOUN", "NOUN", "NAME", "VERB", "OCCUPATION", "ADJECTIVE"]


test_string1 = "Hi, my name is NAME and I really like to VERB PLURALNOUN. I'm also a OCCUPATION at PLACE."
test_string2 = """PERSON! What is PERSON going to do with all these ADJECTIVE PLURALNOUN? Only a registered 
OCCUPATION could VERB them."""
test_string3 = "What a ADJECTIVE day! I can VERB the day off from being a OCCUPATION and go VERB at PLACE."

def word_in_pos(word, parts_of_speech):
    for pos in parts_of_speech:
        if pos in word:
            return pos
    return None

print word_in_pos(test_string1,parts_of_speech1) ### why there is only place in command line using sublime? I thought it should print out all the words in parts_of_speech1 that appear in test_string1, isn't it? 

def play_game(ml_string, parts_of_speech):    
    replaced = []
    ml_string = ml_string.split()
    for word in ml_string:
        replacement = word_in_pos(word, parts_of_speech) ### Does parts_of_speech here refer to parts_of_speech1? what would happen if there is a new parts_of_speech variable before for loop? 
        if replacement != None:
            user_input = raw_input("Type in a: " + replacement + " ") ### Not understand what does raw_input do? Why use it? 
            word = word.replace(replacement, user_input) ### totaly lost...
            replaced.append(word) ### lost...
        else:
            replaced.append(word) 
    replaced = " ".join(replaced)
    return replaced
    
print play_game(test_string1, parts_of_speech1) ### why it has to be done in gib bash to run the game?  why sublime doesn't run it?  why enter winpty python to run it? 
