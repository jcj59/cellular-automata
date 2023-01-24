OChameleon MS3 Report:
Vision:
Our vision is an interactive system in which users can create and observe various cellular automata. Our goal was to have users be able to create Cellular Automata patterns (CA) or use preset patterns with interesting behavior, both in the first or second dimension. We also hoped to be able to switch between different sets of predetermined game rules, such as John Conway’s Game of Life. We have successfully implemented our vision and achieved our goals.

Users are able create their own starter patterns, choose premade patterns, or modify existing patterns. Users are able to determine the rules that dictate automaton behavior. Users can also observe both 1D and 2D automata. Users can also use a GUI to observe continuous behavior. 

Between MS2 and MS3, we strove to extend functionality and complexity, adding additional gamerules for nodes, adding more efficient functions and models, and adding a GUI for a cleaner, visual-based progression of the system using the Graphics module in OCaml. 


Summary of progress:
Between MS2 and MS3, our goals became implemented. We agreed on a reachable goal that would provide a strong foundation for our project: implementing 2D CA, 1D CA, and a GUI visual based on John Conway’s Game of Life’s structure and cell algorithms. We first outlined the functions in the .mli interface, demonstrating what functions should be exposed to the user. This gives the user power to interact and work with our program without needing to know the messy details (i.e. abstraction).

one.ml
`one.ml` contains our implementation of the 1D CA. 
It contains numerous helper functions to factor out repetitive tasks to achieve 1D - namely converting between integers, bits, and bytes, and printing. 1D is entirely accessible via the terminal, where only two commands are required to see results - init_empty and print_loop. The user can determine the length of each game, the rule use (an integer between 0-255), and how many generations run. 

two.ml
`two.ml` contains our implementation of the 2D CA. It contains a number of helper functions to successfully implement our game in OCaml. We allow the user to first select a set of gamerules using the MakeBoard functor. The user can from there select a grid pattern, either the default empty grid or a one of a selection of premade patterns that undergo interesting grow. From there, we allow the user to run a generation at a time, or run many in a loop. This module also provides the underlying implementation that is called and displayed through the GUI.

active.ml
‘active.ml’ contains a more time efficient implementation of 2D CA at the cost of space efficiency.  Active maintains a list of coordinates of nodes that were updated the previous generation of whose neighbor was updated in the previous generation.  This implementation uses the fact that if a node or a neighbor is not updated in the previous generation, then it is guaranteed that it will not be updated in the current generation.  As a result, we are able to lower the time complexity of computing each generation from O(n) to O(a) average where a contains the active nodes in that generation.  The downside is that we must store which nodes are active.  This implementation works by starting with every node on the board being active.  To calculate the next generation, the neighbors of each active node are calculated and added to a separate list.  The active array is then cleared and the nodes in the other list are updated.  When nodes are updated, they are added to the active list along with their neighbors.  This process continues for each generation.

gui.ml
`gui.ml` contains our implementation of the visual GUI of our 2D Cellular Automata. It contains multiple functions, constants, and a runnable function that sequentially calls functions and helpers with aid from the Graphics module in OCaml. The run function utilizes an infinite while-loop for constant progress and grid updates, separated by 1-second delays, to continue its progress until the window is closed or program is halted. The GUI displays a clear representation of our 2D CA implementation, and is easily modified by inputting different game rules and preset game boards from two.ml.

Activity breakdown:
For each team member, give a bulleted list of the responsibilities that team members had, the activities in which they participated, the features they delivered, and the number of hours they spent working.

Ming
Implemented one.ml to completion, with the ability to print the board, generate the board in 1s, and 0s, or to generate the board so it may be read by the GUI.
Kept github working and ensured a quality codebase.
Wrote test cases for one.ml
Bug fixes and overall helpfulness.
30 hours

Jack
Implemented active.ml which is a more efficient version of the basic 2D CA
Organized files and added make targets using dune
Added .ocamlinit file to allow for headless visualization
General debugging of code
30 hours

Ben
Implemented 2D CA with various gamrules
Provided adequate testing and test plan
Helped with GUI
Bug fixing and general code cleanup
30 hours

Jason
Assigned to implement the GUI file, the specifics with opening and running the GUI through a `make gui` command, ensure proper specifications and matches through respective .mli files, and general testing throughout each implementation.
Created and implemented gui.ml and gui.mli, researched the functionality and instructions for running and operating the GUI with new library imports, and added a plethora of tests in test.ml for each implementation of CA. 
Performed final checks on bugs and cleanups on gui.ml, gui.mli, and .mli files across the project. 
Created and structured report file writeup. 
30 hours


Productivity analysis:
As an entire team, we were very productive approaching finals period and the due date. Despite the busy, stressful study period approaching final exams, each member had a set of personal and collaborative tasks and remained productive through the entire sprint approaching the end-date. 

We were able to accomplish all of our main goals, including implementation of  2-D and 1-D Cellular Automata, a more efficient implementation of 2D, adequate testing, and a headless method of visualizing the implementations.

The only goal we weren’t able to fully complete was a more interactive GUI, as well as a GUI implementation for 1D CA. However, a GUI was also our stretch goal, so we are still happy with the progress we made. 

Our estimates of our progress were very accurate, as we worked up to the deadline in order to polish complete implementations of our versions of Cellular Automata with proficient productivity and seamless communication and collaboration – a vast improvement from the period between MS1 and MS2. Our entire team was immersed and interested in the topic of Cellular Automata implementation, and see this topic as a project we are open to furthering past the deadline and the class’s semester. 

