# WZQInstantSearch - An Algorithm For Instant Search

WZQInstantSearch in a swift module designed for searching local documents with user-typed keywords in realtime.

### Usage

- Init A WZQInstantSearch instance with all your texts

An instance of WZQInstantSearch would build an improved **Trie** behind the scene and construct an index for further search.

	let texts = ["An apple a day keeps the doctor away", "whose your daday", "I feel on top of world"]
	let wzq = WZQInstantSearch(texts)
	
For now, you can use `wzq` for any further search requirement.

- Use exposed `Search` function to search related texts with your typed keywords

Suppose You just want to search something related with **Apple**, you just start typing `An App`, etc. You can use `wzq` instance to search as follows:

	let found = wzq.search("An App")
	
If as expected, the `found` will be an array with **An apple a day keeps the doctor away** in it.
	

### How does it work

In a nutshell, we use a combination of **Trie** and **Index Array** to develop this algorithm.

**First Part: Build Trie with given texts**

- Preprocess both search keywords and local texts
- Split long sentences into separate single words
- Calculate the significance of each word.

**Second Part: Search by both whole text search and prefix search**

- To be clarified, we regarded your last sequences of characters as prefix rather than a complete word.
