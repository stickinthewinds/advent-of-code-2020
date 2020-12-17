module file_reader

contains

   ! function to count the number of rows in the file as well as the length of each line
   subroutine count_seats(rows, columns, filename)

      implicit none

      ! import of the name of the file being read
      character(len=32), intent(in) :: filename
      integer :: ios
      integer, parameter :: read_unit = 99
      character(len=100) :: line
      integer :: n

      ! listed as imports because it is a subroutine. these are edited and returned
      integer, intent(out) :: rows, columns

      ! open the file being read
      open (unit=read_unit, file=filename, iostat=ios)
      ! if the file failed to open
      if (ios /= 0) stop "Error opening file "

      ! initialise the number of lines to 0
      n = 0

      do
         ! read the next line
         read (read_unit, '(A)', iostat=ios) line
         ! if there was no next line then exit
         if (ios /= 0) exit
         ! if this is the first line then check the length of the line
         if (n == 0) then ! only need to count the length once
            columns = len(trim(line))
         end if
         n = n + 1
      end do

      ! close the file reader
      close (read_unit)
      rows = n

   end subroutine count_seats

   ! read the file for a second time mapping the lines to an array
   function map_seats(filename, n) result(command)

      implicit none

      ! import filename
      character(len=32), intent(in) :: filename
      integer :: ios
      integer, parameter :: read_unit = 99
      ! create allocatable array where each value is at most a 100 character line
      character(len=100), allocatable :: command(:)
      integer :: n, i

      ! allocate memory for the array based on the number of lines
      allocate (command(n))

      ! open the file to read
      open (unit=read_unit, file=filename, iostat=ios)

      ! read the file and add it to the array
      do i = 1, n
         read (read_unit, '(A)') command(i)
      end do

      ! close the file reader
      close (read_unit)

   end function map_seats

   ! go through each seat checking if it needs to be changed then change them as needed
   function process_seats(seats, rows, columns, part) result(updated)
      implicit none

      ! import the array of seats but also make it editable for return
      character(len=100), allocatable, intent(inout) :: seats(:)
      ! import the number of rows and columns in the seats and the part
      integer, intent(in) :: rows, columns, part
      integer :: i, j
      character :: current

      ! 2d array of 1s and 0s to determine whether or not a value needs to be changed in seats
      integer, dimension(rows, columns) :: changing

      ! boolean showing whether or not a change has occured which is returned
      logical :: updated

      ! make sure changing is initialised as all -1
      do i = 1, rows
         do j = 1, columns
            changing(i, j) = -1
         end do
      end do

      do i = 1, rows
         do j = 1, columns
            current = seats(i) (j:j)
            if (current /= '.') then ! ignore the '.' spots which are the floor
               call update_seat(changing, current, seats, i, j, rows, columns, part)
            end if
         end do
         ! print*, seats(i)
      end do

      ! set updated to false by default
      updated = .FALSE.

      do i = 1, rows
         do j = 1, columns
            ! print *, "Number at ", i, ":", j, "is: ", changing(i, j)
            if (changing(i, j) == 1) then
               updated = .TRUE.
               ! if the value needs to be changed switch between either L or #
               if (seats(i) (j:j) == 'L') then
                  seats(i) (j:j) = '#'
               else
                  seats(i) (j:j) = 'L'
               end if
            end if
         end do
      end do

   end function process_seats

   subroutine update_seat(changing, current, seats, i, j, rowMax, colMax, part)
      implicit none

      ! imports
      character, intent(in) :: current
      character(len=100), allocatable, intent(in) :: seats(:)
      integer, intent(in) :: i, j, rowMax, colMax, part

      integer :: k, l, iMov, jMov

      ! 2d array representing the values that will be changed
      integer, dimension(:, :), intent(inout) :: changing

      k = i
      l = j
      iMov = i + 1
      jMov = j + 1

      if (i == 1) then
         k = i + 1
         iMov = k
      end if
      if (i == rowMax) then
         iMov = i
      end if
      if (j == 1) then
         l = j + 1
         jMov = l
      end if
      if (j == colMax) then
         jMov = j
      end if

      if (part == 1) then
         call check_surroundings_part1(changing, current, seats, k, l, iMov, jMov)
      else if (part == 2) then
         call check_surroundings_part2(changing, current, seats, i, j, rowMax, colMax)
      end if

   end subroutine update_seat

   ! check the 8 surrounding seats for part 1
   subroutine check_surroundings_part1(changing, current, seats, i, j, iMov, jMov)
      implicit none
      character, intent(in) :: current
      character(len=100), allocatable, intent(in) :: seats(:)
      integer, intent(in) :: i, j, iMov, jMov
      integer, dimension(:, :), intent(inout) :: changing
      integer :: k, l, occupied, posI, posJ

      occupied = 0
      posI = i
      posJ = j

      do k = i - 1, iMov
         do l = j - 1, jMov
            if (seats(k) (l:l) == '#') then
               occupied = occupied + 1
            end if
         end do
      end do

      if (iMov == i .AND. i == 2) then
         posI = 1
      end if

      if (jMov == j .AND. j == 2) then
         posJ = 1
      end if

      if (current == 'L') then
         if (occupied == 0) then
            changing(posI, posJ) = 1
         end if
      else if (current == '#' .AND. occupied > 4) then ! greater than because it also checked itself
         changing(posI, posJ) = 1
      else
         changing(posI, posJ) = 0
      end if

   end subroutine

   ! check every visible seat adjacent to the current one for part 2
   subroutine check_surroundings_part2(changing, current, seats, i, j, rowMax, colMax)
      implicit none

      ! imports
      character, intent(in) :: current
      character(len=100), allocatable, intent(in) :: seats(:)
      integer, intent(in) :: i, j, rowMax, colMax

      ! import changing as a return to be edited
      integer, dimension(:, :), intent(inout) :: changing
      integer :: k, l, occupied
      logical :: ignore
      character(len=100) :: seat

      occupied = 0

      ! shitty brute force with a heap of loops
      k = i - 1
      l = j - 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. k > 0 .AND. l > 0)
         seat = seats(k) (l:l)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         k = k - 1
         l = l - 1
      end do

      k = i + 1
      l = j + 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. k <= rowMax .AND. l <= colMax)
         seat = seats(k) (l:l)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         k = k + 1
         l = l + 1
      end do

      k = i - 1
      l = j + 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. k > 0 .AND. l <= colMax)
         seat = seats(k) (l:l)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         k = k - 1
         l = l + 1
      end do

      k = i + 1
      l = j - 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. k <= rowMax .AND. l > 0)
         seat = seats(k) (l:l)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         k = k + 1
         l = l - 1
      end do

      k = i - 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. k > 0)
         seat = seats(k) (j:j)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         k = k - 1
      end do

      k = i + 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. k <= rowMax)
         seat = seats(k) (j:j)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         k = k + 1
      end do

      l = j - 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. l > 0)
         seat = seats(i) (l:l)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         l = l - 1
      end do

      l = j + 1
      ignore = .FALSE.
      do while (.NOT. ignore .AND. l <= colMax)
         seat = seats(i) (l:l)
         ignore = check_seat(seat)
         if (ignore .AND. seat == '#') then
            occupied = occupied + 1
         end if
         l = l + 1
      end do

      if (current == 'L') then
         if (occupied == 0) then
            changing(i, j) = 1
         end if
      else if (current == '#' .AND. occupied > 4) then
         changing(i, j) = 1
      else
         changing(i, j) = 0
      end if

   end subroutine

   function check_seat(seat) result(notFloor)
      implicit none
      character(len=100), intent(in) :: seat
      logical :: notFloor

      notFloor = .FALSE.

      if (seat .NE. '.') then
         notFloor = .TRUE.
      end if
   end function check_seat
end module file_reader
