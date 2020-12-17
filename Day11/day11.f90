program day11

   use file_reader

   character(len=32) :: arg
   integer :: rows, columns
   character(len=100), allocatable :: seats(:)
   logical :: updated = .TRUE.
   integer :: i, occupied

   if (iargc() == 1) then
      call getarg(1, arg)
      print *, "Attempting to read: ", arg
      call count_seats(rows, columns, arg)
      print *, "Rows: ", rows
      print *, "Columns: ", columns
      seats = map_seats(arg, rows)

      do while (updated)
         updated = process_seats(seats, rows, columns)

         print *, "After running functions:"
         do i = 1, rows
            print *, seats(i)
         end do
      end do

      ! count the final number of occupied seats
      occupied = 0
      do i = 1, rows
         do j = 1, columns
            if (seats(i) (j:j) == '#') then
               occupied = occupied + 1
            end if
         end do
      end do

      print *, "Final number of occuped seats: ", occupied

      deallocate (seats)
   else
      print *, "Invalid number of arguments."
      print *, "./day11 filename.txt"
   end if

end program day11
