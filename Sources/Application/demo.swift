import WZQInstantSearch

let texts = ["An apple a day keeps the doctor away", "whose your daday", "I feel on top of world"]
let wzq = WZQInstantSearch(texts)

let ret = wzq.search("an Ap")

print(ret)
