# minesweeper
An simple example of the minesweeper game implemented for iOS with Objective-C

## Just few notes

Before you start to check my app I would like to clarify some aspect that may be important for you.
First of all I would to make clear that I choose to focus my efforts NOT to develop a good interface but a code that would be good to read, understand and extend. I'm quite sure that in your amazing company you have wonderful designer ready to create stunning interface for us, developers. That's why I didn't "waste" time on searching icons on internet or searching the right color combination for the app. I hope your eyes forgive me for this choice.
The second aspect I want to write about is about some choice I made, especially about:
- The board: It could be both implemented with "my solution" or by a matrix of buttons (two for- loops and it's done). I chose to use the CollectionView because I think is more flexible and as another proof of my knowledge about the UI framework
- The leaderboard: was not a requested point. I chose to implement it with a CoreData just to show that I have some basic knowledge also about that.
- The saving system of the board by the NSCoding protocol is another solution that I chose as alternative to CoreData for the same reason.
