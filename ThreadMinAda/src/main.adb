with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Task type Main2 is
      pragma Storage_Size(1_000_000_000);
   end Main2;
   Task body Main2 is

   Dim :  Long_Long_Integer := 99999999;
   Thread_Num : constant Long_Long_Integer := 16;
   MinResult : Long_Long_Integer;
   MinIndex : Long_Long_Integer;

   Arr : array(1..Dim) of Long_Long_Integer;

   procedure Init_Arr is
   begin
      for I in 1..Dim loop
         Arr(I) := Dim - I;
      end loop;
      Arr(Dim) := -1;
   end Init_Arr;

   task type Starter_Thread is
      entry Start(index: Long_Long_Integer; Start_Index, Finish_Index : in Long_Long_Integer);
   end Starter_Thread;

   protected Part_Manager is
      procedure Set_Min_Value(Index : in Long_Long_Integer; Value : in Long_Long_Integer);
      entry Get_Min_Value(Index : out Long_Long_Integer; Value : out Long_Long_Integer);
      procedure IncrementThread;
   private
      Min_Value : Long_Long_Integer := Long_Long_Integer'Last;
      Min_Index : Long_Long_Integer := 0;
      Threads_Completed : Long_Long_Integer := 0;
   end Part_Manager;

   protected body Part_Manager is
      procedure IncrementThread is
      begin
         Threads_Completed := Threads_Completed + 1;
      end IncrementThread;

      procedure Set_Min_Value(Index : in Long_Long_Integer; Value : in Long_Long_Integer) is
      begin
         if Value < Min_Value then
            Min_Value := Value;
            Min_Index := Index;
            MinResult := Value;
            MinIndex := Index;
         end if;
      end Set_Min_Value;

      entry Get_Min_Value(Index : out Long_Long_Integer; Value : out Long_Long_Integer) when Threads_Completed = Thread_Num is
      begin
         Index := Min_Index;
         Value := Min_Value;
      end Get_Min_Value;
   end Part_Manager;

   task body Starter_Thread is
      MinValue : Long_Long_Integer := 1;
      MinIndex : Long_Long_Integer := 1;
      Start_Index, Finish_Index : Long_Long_Integer;
      indexx: Long_Long_Integer;
   begin
      accept Start(index: Long_Long_Integer; Start_Index, Finish_Index : in Long_Long_Integer) do
         Starter_Thread.Start_Index := Start_Index;
         Starter_Thread.Finish_Index := Finish_Index;
         indexx:=index;
      end Start;
      --Put_Line(Start_Index'img & " " & Finish_Index'img);
      Put_Line("Current thread: " & indexx'img);
      for I in Start_Index..Finish_Index loop
         If Arr(MinIndex) > Arr(I) then
            MinIndex := I;
              end if;
      end loop;

      Part_Manager.Set_Min_Value(MinIndex, Arr(MinIndex));
      Part_Manager.IncrementThread;
   end Starter_Thread;


   function Parallel_Min return Long_Long_Integer is
      Value : Long_Long_Integer;
      Index : Long_Long_Integer;
   begin
      Part_Manager.Get_Min_Value(Index, Value);
      return Value;
   end Parallel_Min;

   --ArrThread array(1..Thread_Num) type of;
   type Tasks is array(1..Thread_Num) of Starter_Thread;
   tasks1: Tasks;
begin
   Init_Arr;

   for I in 1..Thread_Num loop
      declare
         Start_Index : Long_Long_Integer := (I - 1) * Dim / Thread_Num + 1;
         Finish_Index : Long_Long_Integer := I * Dim / Thread_Num;
      begin
         if I = Thread_Num then
            Finish_Index := Dim;
         end if;
         tasks1(i).Start(I,Start_Index,Finish_Index);

      end;
   end loop;

   declare
      Min : Long_Long_Integer := 0;
   begin
      Min := Parallel_Min;
      Put_Line("Min value: " & MinResult'Image);
      Put_Line("Min index: " & MinIndex'Image);
      end;
   end Main2;
   program : Main2;
begin
   Null;
end Main;
