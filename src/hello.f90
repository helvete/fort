!
! Fortran FastCGI stack
! Requires:
!    - the FLIBS modules cgi_protocol and fcgi_protocol
!    - the FastCGI library

program run_fcgi

    use fcgi_protocol

    implicit none

    type(DICT_STRUCT), pointer  :: dict => null()
    logical                     :: stopped = .false.
    integer                     :: unitNo

    open(newunit=unitNo, status='scratch')
    ! comment previous line AND uncomment next line for debugging;
    !open(newunit=unitNo, file='fcgiout', status='unknown') ! file 'fcgiout' will show %REMARKS%

    ! variables from webserver
    do while (fcgip_accept_environment_variables() >= 0)

        ! build dictionary from GET or POST data, environment variables
        call fcgip_make_dictionary(dict, unitNo)

        ! give dictionary to the user supplied routine
        ! routine writes the response to unitNo
        ! routine sets stopped to true to terminate program
        call respond(dict, unitNo, stopped)

        ! copy file unitNo to the webserver
        call fcgip_put_file(unitNo, 'text/plain')

        ! terminate?
        if (stopped) exit

    end do

    close(unitNo)

    unitNo = fcgip_accept_environment_variables()


contains
    subroutine respond (dict, unitNo, stopped)

        type(DICT_STRUCT), pointer        :: dict
        integer, intent(in)               :: unitNo
        logical, intent(out)              :: stopped

        ! the following are defined in fcgi_protocol
        !character(len=3), parameter :: AFORMAT = '(a)'
        !character(len=2), parameter :: CRLF = achar(13)//achar(10)
        !character(len=1), parameter :: NUL = achar(0)

        ! retrieve params from model and pass them to view
        character(len=50), dimension(10,2) :: pagevars
        character(len=50), dimension(8) :: vari

        ! the script name
        character(len=80)  :: scriptName, query

        logical                           :: okInputs

        ! start of response
        ! lines starting with %REMARK% are for debugging & will not be copied to webserver
        write(unitNo, AFORMAT) &
            '%REMARK% respond() started ...', &
            ''

        ! retrieve script name (key=DOCUMENT_URI) from dictionary
        call cgi_get(dict, "DOCUMENT_URI", scriptName)

        select case (trim(scriptName))
          case ('/')
                write(unitNo, AFORMAT) 'Hello world!'
          case DEFAULT
            ! your 404 page
            write(unitNo, AFORMAT) 'Page not found!'
        end select

        ! end of response
        write(unitNo, AFORMAT) '', &
            '%REMARK% respond() completed ...'

        return

    end subroutine respond

end program run_fcgi
