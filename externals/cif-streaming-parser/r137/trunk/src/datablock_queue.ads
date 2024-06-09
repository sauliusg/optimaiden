with Ada.Containers.Bounded_Synchronized_Queues;
with Ada.Containers.Synchronized_Queue_Interfaces;
with Cif_Datablock; use Cif_Datablock;

package Datablock_Queue is

  package Datablock_Queue_Interface is new Ada.Containers
   .Synchronized_Queue_Interfaces
   (Element_Type => Controlled_Datablock_Access);

  package Datablock_Bounded_Queue is new Ada.Containers
  .Bounded_Synchronized_Queues
   (Queue_Interfaces => Datablock_Queue_Interface, Default_Capacity => 5);

end Datablock_Queue;
