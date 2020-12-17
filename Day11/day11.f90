program day11

   use file_reader

   character(len=32) :: arg
   integer :: rows, columns
   character(len=100), allocatable :: seats(:)
   logical :: updated
   integer :: part, i, occupied

   if (iargc() == 1) then
      call getarg(1, arg)
      print *, "Attempting to read: ", arg
      call count_seats(rows, columns, arg)
      print *, "Rows: ", rows
      print *, "Columns: ", columns

      do part = 1, 2
         seats = map_seats(arg, rows)

         print *, "Initial layout:"
         do i = 1, rows
            print *, seats(i)
         end do

         updated = .TRUE.
         do while (updated)
            updated = process_seats(seats, rows, columns, part)

            print *, "After running part", part, "functions:"
            do i = 1, rows
               print *, seats(i)
            end do
         end do

         ! count the final number of occupied seats for part 1
         occupied = 0
         do i = 1, rows
            do j = 1, columns
               if (seats(i) (j:j) == '#') then
                  occupied = occupied + 1
               end if
            end do
         end do

         print *, "Final number of occupied seats for part ", part, ": ", occupied

         deallocate (seats)
      end do
   else
      print *, "Invalid number of arguments."
      print *, "./day11 filename.txt"
   end if

end program day11
