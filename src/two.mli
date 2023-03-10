(* two_matrix is the 2 dimensional implementation of the Game of Life. The game
   is represented in a 2D that updates upon each generation. Each node has 8
   neighbors, which affects whether it lives or dies on the next round. This
   implementation allows the user to generate preset patterns or input their own
   manually, and run the pattern for generations. *)

(** [BSRules] contains information about the gamerules for a 2D CA *)
module type BSRules = sig
  val born : int list
  (** [born] is all the possible number of neighbors in which a dead node will
      become alive *)

  val survive : int list
  (** [survive] is all the possible number of neighbors in which an alive node
      will stay alive *)
end

module B3_S23 : BSRules
(** [B3_S23] contains the gamerules for Conway's Game of Life *)

module B36_S23 : BSRules
(** [B36_S23] contains the gamerules for Highlife *)

module B3678_S34678 : BSRules
(** [B3678_S34678] contains the gamerules for Day and Night *)

module B2_S : BSRules
(** [B2_S] contains the gamerules for Seeds *)

(** [Board] contains the neccessary functions to observe 2D CA accorrding to
    specific gamerules *)
module type Board = sig
  (** [state] represents the state of a node. Either [Dead] or [Alive] *)
  type state =
    | Dead
    | Alive

  type gameboard = state array array
  (** Two dimensional array of nodes representing a gameboard. Top left corner
      is (0, 0), increasing in x and y when moving right and down respectively *)

  exception AlreadyAlive
  (** [AlreadyAlive] is raised when a node containing an [Alive] node is
      attempted to be birthed *)

  exception AlreadyDead
  (** [AlreadyDead] is raised when a node containing an [Dead] node is attempted
      to be killed *)

  exception PreconditionViolation of string
  (** [PreconditionViolation s] is raised when the precondition of a funciton is
      violated. [s] tells which function raised this excpetion *)

  val born_rule : int list
  (** [born_rule] is all the possible number of neighbors in which a dead node
      will become alive *)

  val survive_rule : int list
  (** [survive_rule] is all the possible number of neighbors in which an alive
      node will stay alive *)

  val get : gameboard -> int -> int -> state
  (** [get g x y] is the state of the node at coordinate position (x,y) with the
      top left corner being (0, 0), increasing in x and y when moving right and
      down respectively. Requires: ([x], [y]) must be a valid position in the
      grid *)

  val birth_node : gameboard -> int -> int -> unit
  (** [birth_node g x y] checks the state of the node at grid position [x], [y]
      in gameboard g. If that node is dead, it is updated to be alive. Raises
      AlreadyAlive if the node at position [x], [y] is already alive. Requires:
      ([x], [y]) must be a valid position in the grid.*)

  val kill_node : gameboard -> int -> int -> unit
  (** [kill_node g x y] checks the state of the node at grid position [x], [y]
      in gameboard g. If that node is alice, it is updated to be dead. Raises
      AlreadyDead if the node at position [x], [y] is already dead. Requires:
      ([x], [y]) must be a valid position in the grid.*)

  val neighbors : gameboard -> int -> int -> int
  (** [neighbors g x y] is the number of alive neighbors that the node located
      at position ([x], [y]) on the grid has. Neighbors are located directly to
      either side, diagonally, above, and below the original node. Requires:
      ([x], [y]) must be a valid position in the grid. *)

  val update_node : gameboard -> int -> int -> int -> unit
  (** [update_node gb x y n] updates the node at (x,y) in gamebaord g with n
      neighbors in the previous generation to be dead or alive for the next
      generation, based on its number neighbors and according to the rules of
      the board. Requires: (x,y) is a valid coordinate of a node on the
      gameboard. *)

  val update_board : gameboard -> unit
  (** [update_board gb] updates gameboard [gb] to the next generation *)

  val string_of_board : gameboard -> string
  (** [string_of_board gb] is the string representation of gameboard gb *)

  val print_board : gameboard -> unit
  (** [print_board g] prints [g]. *)

  val loop : gameboard -> int -> unit
  (** [loop g i] loops through [i] generations of the Game of Life with
      gameboard [g], printing each time the board is updated *)

  val init_empty : int -> int -> gameboard
  (** [init_gameboard x y] is a gameboard with dimensions [x] by [y] with all
      dead nodes. Requires: [x > 0] and [y > 0] *)

  val init_glider : unit -> gameboard
  (** [init_glider ()] is a glider centered on a 10x10 grid. Has interesting
      applications in Conway's Game of Life (B3_S23) *)

  val init_replicator : unit -> gameboard
  (** [init_replicator ()] is a replicator centered on a 18x18 grid. Has
      intereting applications in Highlife (B36_S23) *)

  val init_rocket : unit -> gameboard
  (** [init_rocket ()] is a rocket centered on a 20x15 grid. Has intereting
      applications in Day and Night (B34678_S3678) *)

  val init_seed : unit -> gameboard
  (** [init_seed ()] is a seed centered on a 18x18 grid. Has intereting
      applications in Seeds (B2_S) *)

  val make_board : int -> int -> (int * int) list -> gameboard
  (** [make_board x y c] is a gameboard with dimensions [x] by [y] and alive
      nodes at each coordinate specified in [c] *)
end

(** [MakeBoard] makes a [Board] according to the rules specified by [BSRules] *)
module MakeBoard : functor (_ : BSRules) -> Board
