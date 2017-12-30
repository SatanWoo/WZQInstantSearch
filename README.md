# WZQInstantSearch - An Algorithm For Instant Search

WZQInstantSearch in a swift module designed for searching local documents with user-typed keywords in realtime.

### Usage

- Init A WZQInstantSearch instance with all your texts

An instance of WZQInstantSearch would build an improved **Trie** behind the scene and construct an index for further search.

	let texts = ["An apple a day keeps the doctor away", "whose your daday", "I feel on top of world"]
	let wzq = WZQInstantSearch(texts)
	
For now, you can use wzq for any further search requirement.

- use exposed `Search` function to search related texts with your typed keywords

Suppose You just want to search 
		let found = wzq.search("An App")
	

### How does it work

In a nutshell, we use a combination of **Trie** and **Index Array** to develop this algorithm.



Suppose you have different texts in your local data storage system and you want to show related matches with keywords. 


