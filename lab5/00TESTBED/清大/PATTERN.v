`ifdef RTL
`define CYCLE_TIME 12.0
`endif
`ifdef GATE
`define CYCLE_TIME 12.0
`endif

module PATTERN(
        // input signals
        clk,
        rst_n,
        in_valid,
        in_data,
        size,
        action,   
        // output signals
        out_valid,
        out_data
);
//======================================
//          I/O PORTS
//======================================
output reg        clk;
output reg        rst_n;
output reg        in_valid;
output reg [30:0] in_data;
output reg [1:0]  size;
output reg [2:0]  action;
input             out_valid;
input      [30:0] out_data;


//======================================
//      PARAMETERS & VARIABLES
//======================================
parameter PATNUM = 1000;
parameter CYCLE  = `CYCLE_TIME;
parameter DELAY  = 25000;
integer   SEED   = 639;

integer       i;
integer       j;
integer       m;
integer       n;
integer     pat;
integer exe_lat;
integer out_lat;

// branch
integer    mode;

// set up
integer     pow;
integer     len;

// matrix
integer    gold     [0:15][0:15];
integer    matrix_in[0:15][0:15];
integer    your     [0:15][0:15];

reg signed[99:0] matrix_temp[0:15][0:15];

//======================================
//      CLOCK
//======================================
initial clk = 1'b0;
always #(CYCLE/2.0) clk = ~clk;

//======================================
//              MAIN
//======================================
initial exe_task;

//======================================
//              TASKS
//======================================
task exe_task; begin
    reset_task;
    for (pat=0 ; pat<1000 ; pat=pat+1) begin
        branch_task;
        if (mode==0)      setup_task;
        else if (mode==1) add_task;
        else if (mode==2) mult_task;
        else if (mode==3) tran_task;
        else if (mode==4) mirr_task;
        else              rota_task;
    end
    pass_task;

end endtask

task reset_task; begin
    force clk = 0;
    rst_n     = 1;
    in_valid  = 0;
    in_data   = 31'dx;
    size      = 2'dx;
    action    = 3'dx;

    #(CYCLE/2.0) rst_n = 0;
    #(CYCLE/2.0) rst_n = 1;
    if ( out_valid !== 0 || out_data !== 0 ) begin       
        $display("                                           `:::::`                                                       ");
        $display("                                          .+-----++                                                      ");
        $display("                .--.`                    o:------/o                                                      ");
        $display("              /+:--:o/                   //-------y.          -//:::-        `.`                         ");
        $display("            `/:------y:                  `o:--::::s/..``    `/:-----s-    .:/:::+:                       ");
        $display("            +:-------:y                `.-:+///::-::::://:-.o-------:o  `/:------s-                      ");
        $display("            y---------y-        ..--:::::------------------+/-------/+ `+:-------/s                      ");
        $display("           `s---------/s       +:/++/----------------------/+-------s.`o:--------/s                      ");
        $display("           .s----------y-      o-:----:---------------------/------o: +:---------o:                      ");
        $display("           `y----------:y      /:----:/-------/o+----------------:+- //----------y`                      ");
        $display("            y-----------o/ `.--+--/:-/+--------:+o--------------:o: :+----------/o                       ");
        $display("            s:----------:y/-::::::my-/:----------/---------------+:-o-----------y.                       ");
        $display("            -o----------s/-:hmmdy/o+/:---------------------------++o-----------/o                        ");
        $display("             s:--------/o--hMMMMMh---------:ho-------------------yo-----------:s`                        ");
        $display("             :o--------s/--hMMMMNs---------:hs------------------+s------------s-                         ");
        $display("              y:-------o+--oyhyo/-----------------------------:o+------------o-                          ");
        $display("              -o-------:y--/s--------------------------------/o:------------o/                           ");
        $display("               +/-------o+--++-----------:+/---------------:o/-------------+/                            ");
        $display("               `o:-------s:--/+:-------/o+-:------------::+d:-------------o/                             ");
        $display("                `o-------:s:---ohsoosyhh+----------:/+ooyhhh-------------o:                              ");
        $display("                 .o-------/d/--:h++ohy/---------:osyyyyhhyyd-----------:o-                               ");
        $display("                 .dy::/+syhhh+-::/::---------/osyyysyhhysssd+---------/o`                                ");
        $display("                  /shhyyyymhyys://-------:/oyyysyhyydysssssyho-------od:                                 ");
        $display("                    `:hhysymmhyhs/:://+osyyssssydyydyssssssssyyo+//+ymo`                                 ");
        $display("                      `+hyydyhdyyyyyyyyyyssssshhsshyssssssssssssyyyo:`                                   ");
        $display("                        -shdssyyyyyhhhhhyssssyyssshssssssssssssyy+.    Output signal should be 0         ");
        $display("                         `hysssyyyysssssssssssssssyssssssssssshh+                                        ");
        $display("                        :yysssssssssssssssssssssssssssssssssyhysh-     after the reset signal is asserted");
        $display("                      .yyhhdo++oosyyyyssssssssssssssssssssssyyssyh/                                      ");
        $display("                      .dhyh/--------/+oyyyssssssssssssssssssssssssy:   at %4d ps                         ", $time*1000);
        $display("                       .+h/-------------:/osyyysssssssssssssssyyh/.                                      ");
        $display("                        :+------------------::+oossyyyyyyyysso+/s-                                       ");
        $display("                       `s--------------------------::::::::-----:o                                       ");
        $display("                       +:----------------------------------------y`                                      ");
        repeat(5) #(CYCLE);
        $finish;
    end
 
    #(CYCLE/2.0) release clk;

end endtask

task branch_task; begin
    repeat($urandom_range(3,5)) @(negedge clk);   
    if ( pat==0 ) begin
        mode = 0;
    end
    else begin
        mode = $urandom_range(1,5);
    end
end endtask

task setup_task; begin

    // Only setup can change size
    if ( mode==0 ) begin
        pow = ($urandom(SEED)%4 + 1);
        len = 1;
        for ( i=0 ; i<pow ; i=i+1 ) begin
            len = 2*len;
        end
    end
     
    // Input Matrix
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            if ( i!=0 || j!=0 ) begin
                if ( out_valid === 1 ) begin
                    $display("                                                                 ``...`                                ");
                    $display("     Out_valid can't overlap in_valid!!!                      `.-:::///:-::`                           "); 
                    $display("                                                            .::-----------/s.                          "); 
                    $display("                                                          `/+-----------.--+s.`                        "); 
                    $display("                                                         .+y---------------/m///:-.                    "); 
                    $display("                         ``.--------.-..``            `:+/mo----------:/+::ys----/++-`                 "); 
                    $display("                     `.:::-:----------:::://-``     `/+:--yy----/:/oyo+/:+o/-------:+o:-:/++//::.`     "); 
                    $display("                  `-//::-------------------:/++:.` .+/----/ho:--:/+/:--//:-----------:sd/------://:`   "); 
                    $display("                .:+/----------------------:+ooshdyss:-------::-------------------------od:--------::   ");
                    $display("              ./+:--------------------:+ssosssyyymh-------------------------------------+h/---------   ");
                    $display("             :s/-------------------:osso+osyssssdd:--------------------------------------+myoos+/:--   ");
                    $display("           `++-------------------:oso+++os++osshm:----------------------------------------ss--/:---/   ");
                    $display("          .s/-------------------sho+++++++ohyyodo-----------------------------------------:ds+//+/:.   "); 
                    $display("         .y/------------------/ys+++++++++sdsdym:------------------------------------------/y---.`     "); 
                    $display("        .d/------------------oy+++++++++++omyhNd--------------------------------------------+:         "); 
                    $display("       `yy------------------+h++++++++++++ydhohy---------------------------------------------+.        "); 
                    $display("       -m/-----------------:ho++++++++++++odyhoho--------------------/++:---------------------:        "); 
                    $display("       +y------------------ss+++++++++++ossyoshod+-----------------+ss++y:--------------------+`       "); 
                    $display("       y+-//::------------:ho++++++++++osyhddyyoom/---------------::------------------/syh+--+/        "); 
                    $display("      `hy:::::////:-/:----+d+++++++++++++++++oshhhd--------------------------------------/m+++`        "); 
                    $display("      `hs--------/oo//+---/d++++++++++++++++++++sdN+-------------------------------:------:so`         "); 
                    $display("       :s----------:+y++:-/d++++++++++++++++++++++sh+--------------:+-----+--------s--::---os          "); 
                    $display("       .h------------:ssy-:mo++++++++++++++++++++++om+---------------+s++ys----::-:s/+so---/+/.        "); 
                    $display("    `:::yy-------------/do-hy+++++o+++++++++++++++++oyyo--------------::::--:///++++o+/:------y.       "); 
                    $display("  `:/:---ho-------------:yoom+++++hsh++++++++++++ossyyhNs---------------------+hmNmdys:-------h.       "); 
                    $display(" `/:-----:y+------------.-sshy++++ohNy++++++++sso+/:---sy--------------------/NMMMMMNhs-----+s/        "); 
                    $display(" +:-------:ho-------------:homo+++++hmo+++++oho:--------ss///////:------------yNMMMNdoy//+shd/`        "); 
                    $display(" y---------:hs/------------+yod++++++hdo+++odo------------::::://+oo+o/--------/oso+oo::/sy+:o/        "); 
                    $display(" y----/+:---::so:----------/m-sdo+oyo+ydo+ody------------------------/oo/------:/+oo/-----::--h.       "); 
                    $display(" oo---/ss+:----:/----------+y--+hyooysoydshh----------------------------ohosshhs++:----------:y`       "); 
                    $display(" `/oo++oosyo/:------------:yy++//sdysyhhydNdo:---------------------------shdNN+-------------+y-        "); 
                    $display("    ``...``.-:/+////::-::/:.`.-::---::+oosyhdhs+/:-----------------------/s//oy:---------:os+.         "); 
                    $display("               `.-:://---.                 ````.:+o/::-----------------:/o`  `-://::://:---`           "); 
                    $display("                                                  `.-//+o////::/::///++:.`           ``                "); 
                    $display("                                                        ``..-----....`                                 ");
                    $display("\033[1;0m");
                    repeat(5) @(negedge clk);
                    $finish;
                end    
            end
            in_valid = 1;
            size     = i ? 'dx : (j ? 'dx : pow-1);
            action   = i ? 'dx : (j ? 'dx : 0);
            if ( pat < 500 ) in_data = {$random(SEED)} % 100;
            else             in_data = {$random(SEED)} % 2147483647;  
            gold[i][j] = in_data;
            @(negedge clk);
        end
    end

    in_valid = 0;
    size     = 'dx;
    action   = 'dx;
    in_data  = 'dx;
   
    wait_task;
    check_task;
end endtask

task add_task; begin

    // Prepare input matix
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            if ( pat < 500 ) matrix_in[i][j] = {$random(SEED)} % 100;
            else             matrix_in[i][j] = {$random(SEED)} % 2147483647;
        end
    end
    
    // Calculate output matrix
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            matrix_temp[i][j] = gold[i][j] + matrix_in[i][j];
        end
    end

    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            gold[i][j] = matrix_temp[i][j] % 31'h7fffffff;
        end
    end

    // Inout weight for convolution
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            if ( i!=0 || j!=0 ) begin
                if ( out_valid === 1 ) begin
                    $display("                                                                 ``...`                                ");
                    $display("     Out_valid can't overlap in_valid!!!                      `.-:::///:-::`                           "); 
                    $display("                                                            .::-----------/s.                          "); 
                    $display("                                                          `/+-----------.--+s.`                        "); 
                    $display("                                                         .+y---------------/m///:-.                    "); 
                    $display("                         ``.--------.-..``            `:+/mo----------:/+::ys----/++-`                 "); 
                    $display("                     `.:::-:----------:::://-``     `/+:--yy----/:/oyo+/:+o/-------:+o:-:/++//::.`     "); 
                    $display("                  `-//::-------------------:/++:.` .+/----/ho:--:/+/:--//:-----------:sd/------://:`   "); 
                    $display("                .:+/----------------------:+ooshdyss:-------::-------------------------od:--------::   ");
                    $display("              ./+:--------------------:+ssosssyyymh-------------------------------------+h/---------   ");
                    $display("             :s/-------------------:osso+osyssssdd:--------------------------------------+myoos+/:--   ");
                    $display("           `++-------------------:oso+++os++osshm:----------------------------------------ss--/:---/   ");
                    $display("          .s/-------------------sho+++++++ohyyodo-----------------------------------------:ds+//+/:.   "); 
                    $display("         .y/------------------/ys+++++++++sdsdym:------------------------------------------/y---.`     "); 
                    $display("        .d/------------------oy+++++++++++omyhNd--------------------------------------------+:         "); 
                    $display("       `yy------------------+h++++++++++++ydhohy---------------------------------------------+.        "); 
                    $display("       -m/-----------------:ho++++++++++++odyhoho--------------------/++:---------------------:        "); 
                    $display("       +y------------------ss+++++++++++ossyoshod+-----------------+ss++y:--------------------+`       "); 
                    $display("       y+-//::------------:ho++++++++++osyhddyyoom/---------------::------------------/syh+--+/        "); 
                    $display("      `hy:::::////:-/:----+d+++++++++++++++++oshhhd--------------------------------------/m+++`        "); 
                    $display("      `hs--------/oo//+---/d++++++++++++++++++++sdN+-------------------------------:------:so`         "); 
                    $display("       :s----------:+y++:-/d++++++++++++++++++++++sh+--------------:+-----+--------s--::---os          "); 
                    $display("       .h------------:ssy-:mo++++++++++++++++++++++om+---------------+s++ys----::-:s/+so---/+/.        "); 
                    $display("    `:::yy-------------/do-hy+++++o+++++++++++++++++oyyo--------------::::--:///++++o+/:------y.       "); 
                    $display("  `:/:---ho-------------:yoom+++++hsh++++++++++++ossyyhNs---------------------+hmNmdys:-------h.       "); 
                    $display(" `/:-----:y+------------.-sshy++++ohNy++++++++sso+/:---sy--------------------/NMMMMMNhs-----+s/        "); 
                    $display(" +:-------:ho-------------:homo+++++hmo+++++oho:--------ss///////:------------yNMMMNdoy//+shd/`        "); 
                    $display(" y---------:hs/------------+yod++++++hdo+++odo------------::::://+oo+o/--------/oso+oo::/sy+:o/        "); 
                    $display(" y----/+:---::so:----------/m-sdo+oyo+ydo+ody------------------------/oo/------:/+oo/-----::--h.       "); 
                    $display(" oo---/ss+:----:/----------+y--+hyooysoydshh----------------------------ohosshhs++:----------:y`       "); 
                    $display(" `/oo++oosyo/:------------:yy++//sdysyhhydNdo:---------------------------shdNN+-------------+y-        "); 
                    $display("    ``...``.-:/+////::-::/:.`.-::---::+oosyhdhs+/:-----------------------/s//oy:---------:os+.         "); 
                    $display("               `.-:://---.                 ````.:+o/::-----------------:/o`  `-://::://:---`           "); 
                    $display("                                                  `.-//+o////::/::///++:.`           ``                "); 
                    $display("                                                        ``..-----....`                                 ");
                    $display("\033[1;0m");
                    repeat(5) @(negedge clk);
                    $finish;
                end    
            end
            in_valid = 1;
            action   = i ? 'dx : (j ? 'dx : 2);
            in_data  = matrix_in[i][j];
            @(negedge clk);
        end
    end

    in_valid = 0;
    action   = 'dx;
    in_data  = 'dx;
    
    wait_task;
    check_task;
end endtask

task mult_task; begin

    // Prepare input matrix
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            if ( pat < 500 ) matrix_in[i][j] = {$random(SEED)} % 100;
            else             matrix_in[i][j] = {$random(SEED)} % 2147483647;
        end
    end
    
    // Calculate output matrix
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            matrix_temp[i][j] = 0;
        end
    end

    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            for ( m=0 ; m<len ; m=m+1 ) begin
            	matrix_temp[i][j] = matrix_temp[i][j] + gold[i][m] * matrix_in[m][j];
           	end
        end
    end


    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            gold[i][j] = matrix_temp[i][j] % 31'h7fffffff;
        end
    end

    // Inout weight for convolution
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            if ( i!=0 || j!=0 ) begin
                if ( out_valid === 1 ) begin
                    $display("                                                                 ``...`                                ");
                    $display("     Out_valid can't overlap in_valid!!!                      `.-:::///:-::`                           "); 
                    $display("                                                            .::-----------/s.                          "); 
                    $display("                                                          `/+-----------.--+s.`                        "); 
                    $display("                                                         .+y---------------/m///:-.                    "); 
                    $display("                         ``.--------.-..``            `:+/mo----------:/+::ys----/++-`                 "); 
                    $display("                     `.:::-:----------:::://-``     `/+:--yy----/:/oyo+/:+o/-------:+o:-:/++//::.`     "); 
                    $display("                  `-//::-------------------:/++:.` .+/----/ho:--:/+/:--//:-----------:sd/------://:`   "); 
                    $display("                .:+/----------------------:+ooshdyss:-------::-------------------------od:--------::   ");
                    $display("              ./+:--------------------:+ssosssyyymh-------------------------------------+h/---------   ");
                    $display("             :s/-------------------:osso+osyssssdd:--------------------------------------+myoos+/:--   ");
                    $display("           `++-------------------:oso+++os++osshm:----------------------------------------ss--/:---/   ");
                    $display("          .s/-------------------sho+++++++ohyyodo-----------------------------------------:ds+//+/:.   "); 
                    $display("         .y/------------------/ys+++++++++sdsdym:------------------------------------------/y---.`     "); 
                    $display("        .d/------------------oy+++++++++++omyhNd--------------------------------------------+:         "); 
                    $display("       `yy------------------+h++++++++++++ydhohy---------------------------------------------+.        "); 
                    $display("       -m/-----------------:ho++++++++++++odyhoho--------------------/++:---------------------:        "); 
                    $display("       +y------------------ss+++++++++++ossyoshod+-----------------+ss++y:--------------------+`       "); 
                    $display("       y+-//::------------:ho++++++++++osyhddyyoom/---------------::------------------/syh+--+/        "); 
                    $display("      `hy:::::////:-/:----+d+++++++++++++++++oshhhd--------------------------------------/m+++`        "); 
                    $display("      `hs--------/oo//+---/d++++++++++++++++++++sdN+-------------------------------:------:so`         "); 
                    $display("       :s----------:+y++:-/d++++++++++++++++++++++sh+--------------:+-----+--------s--::---os          "); 
                    $display("       .h------------:ssy-:mo++++++++++++++++++++++om+---------------+s++ys----::-:s/+so---/+/.        "); 
                    $display("    `:::yy-------------/do-hy+++++o+++++++++++++++++oyyo--------------::::--:///++++o+/:------y.       "); 
                    $display("  `:/:---ho-------------:yoom+++++hsh++++++++++++ossyyhNs---------------------+hmNmdys:-------h.       "); 
                    $display(" `/:-----:y+------------.-sshy++++ohNy++++++++sso+/:---sy--------------------/NMMMMMNhs-----+s/        "); 
                    $display(" +:-------:ho-------------:homo+++++hmo+++++oho:--------ss///////:------------yNMMMNdoy//+shd/`        "); 
                    $display(" y---------:hs/------------+yod++++++hdo+++odo------------::::://+oo+o/--------/oso+oo::/sy+:o/        "); 
                    $display(" y----/+:---::so:----------/m-sdo+oyo+ydo+ody------------------------/oo/------:/+oo/-----::--h.       "); 
                    $display(" oo---/ss+:----:/----------+y--+hyooysoydshh----------------------------ohosshhs++:----------:y`       "); 
                    $display(" `/oo++oosyo/:------------:yy++//sdysyhhydNdo:---------------------------shdNN+-------------+y-        "); 
                    $display("    ``...``.-:/+////::-::/:.`.-::---::+oosyhdhs+/:-----------------------/s//oy:---------:os+.         "); 
                    $display("               `.-:://---.                 ````.:+o/::-----------------:/o`  `-://::://:---`           "); 
                    $display("                                                  `.-//+o////::/::///++:.`           ``                "); 
                    $display("                                                        ``..-----....`                                 ");
                    $display("\033[1;0m");
                    repeat(5) @(negedge clk);
                    $finish;
                end    
            end
            in_valid = 1;
            action   = i ? 'dx : (j ? 'dx : 2);
            in_data  = matrix_in[i][j];
            @(negedge clk);
        end
    end

    in_valid = 0;
    action   = 'dx;
    in_data  = 'dx;
    
    wait_task;
    check_task;
end endtask

task tran_task; begin
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            matrix_temp[j][i] = gold[i][j];
        end
    end

    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            gold[i][j] = matrix_temp[i][j];
        end
    end    
    
    in_valid = 1;
    action   = 'd3;
    @(negedge clk);
    
    in_valid = 0;
    action   = 'dx;
    
    wait_task;
    check_task;
end endtask

task mirr_task; begin
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            matrix_temp[i][len-j-1] = gold[i][j];
        end
    end

    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            gold[i][j] = matrix_temp[i][j];
        end
    end    
    
    in_valid = 1;
    action   = 'd4;
    @(negedge clk);
    
    in_valid = 0;
    action   = 'dx;
    
    wait_task;
    check_task;
end endtask

task rota_task; begin
    for ( i=0 ; i<len/2 ; i=i+1 ) begin
        for ( j=i ; j<len-i-1 ; j=j+1 ) begin
            matrix_temp[0][0]      = gold[i][j];
            gold[i][j]             = gold[j][len-1-i];
            gold[j][len-1-i]       = gold[len-1-i][len-1-j];
            gold[len-1-i][len-1-j] = gold[len-1-j][i];
            gold[len-1-j][i]       = matrix_temp[0][0];
        end
    end  
    
    in_valid = 1;
    action   = 'd5;
    @(negedge clk);
    
    in_valid = 0;
    action   = 'dx;
    
    wait_task;
    check_task;
end endtask

task wait_task; begin
    exe_lat = -1;
    while ( out_valid!==1 ) begin
        if ( out_valid !== 0 || out_data !== 0 ) begin       
            $display("                                           `:::::`                                                       ");
            $display("                                          .+-----++                                                      ");
            $display("                .--.`                    o:------/o                                                      ");
            $display("              /+:--:o/                   //-------y.          -//:::-        `.`                         ");
            $display("            `/:------y:                  `o:--::::s/..``    `/:-----s-    .:/:::+:                       ");
            $display("            +:-------:y                `.-:+///::-::::://:-.o-------:o  `/:------s-                      ");
            $display("            y---------y-        ..--:::::------------------+/-------/+ `+:-------/s                      ");
            $display("           `s---------/s       +:/++/----------------------/+-------s.`o:--------/s                      ");
            $display("           .s----------y-      o-:----:---------------------/------o: +:---------o:                      ");
            $display("           `y----------:y      /:----:/-------/o+----------------:+- //----------y`                      ");
            $display("            y-----------o/ `.--+--/:-/+--------:+o--------------:o: :+----------/o                       ");
            $display("            s:----------:y/-::::::my-/:----------/---------------+:-o-----------y.                       ");
            $display("            -o----------s/-:hmmdy/o+/:---------------------------++o-----------/o                        ");
            $display("             s:--------/o--hMMMMMh---------:ho-------------------yo-----------:s`                        ");
            $display("             :o--------s/--hMMMMNs---------:hs------------------+s------------s-                         ");
            $display("              y:-------o+--oyhyo/-----------------------------:o+------------o-                          ");
            $display("              -o-------:y--/s--------------------------------/o:------------o/                           ");
            $display("               +/-------o+--++-----------:+/---------------:o/-------------+/                            ");
            $display("               `o:-------s:--/+:-------/o+-:------------::+d:-------------o/                             ");
            $display("                `o-------:s:---ohsoosyhh+----------:/+ooyhhh-------------o:                              ");
            $display("                 .o-------/d/--:h++ohy/---------:osyyyyhhyyd-----------:o-                               ");
            $display("                 .dy::/+syhhh+-::/::---------/osyyysyhhysssd+---------/o`                                ");
            $display("                  /shhyyyymhyys://-------:/oyyysyhyydysssssyho-------od:                                 ");
            $display("                    `:hhysymmhyhs/:://+osyyssssydyydyssssssssyyo+//+ymo`                                 ");
            $display("                      `+hyydyhdyyyyyyyyyyssssshhsshyssssssssssssyyyo:`                                   ");
            $display("                        -shdssyyyyyhhhhhyssssyyssshssssssssssssyy+.    Output signal should be 0         ");
            $display("                         `hysssyyyysssssssssssssssyssssssssssshh+                                        ");
            $display("                        :yysssssssssssssssssssssssssssssssssyhysh-     when the out_valid is pulled down ");
            $display("                      .yyhhdo++oosyyyyssssssssssssssssssssssyyssyh/                                      ");
            $display("                      .dhyh/--------/+oyyyssssssssssssssssssssssssy:   at %4d ps                         ", $time*1000);
            $display("                       .+h/-------------:/osyyysssssssssssssssyyh/.                                      ");
            $display("                        :+------------------::+oossyyyyyyyysso+/s-                                       ");
            $display("                       `s--------------------------::::::::-----:o                                       ");
            $display("                       +:----------------------------------------y`                                      ");
            repeat(5) #(CYCLE);
            $finish;
        end
        if (exe_lat == DELAY) begin
            $display("                                   ..--.                                ");                          
            $display("                                `:/:-:::/-                              ");                         
            $display("                                `/:-------o                             ");
            $display("                                /-------:o:                             "); 
            $display("                                +-:////+s/::--..                        ");                         
            $display("    The execution latency      .o+/:::::----::::/:-.       at %-12d ps  ", $time*1000);                         
            $display("    is over 5000 cycles       `:::--:/++:----------::/:.                ");                          
            $display("                            -+:--:++////-------------::/-               ");                          
            $display("                            .+---------------------------:/--::::::.`   ");                          
            $display("                          `.+-----------------------------:o/------::.  ");                          
            $display("                       .-::-----------------------------:--:o:-------:  ");                          
            $display("                     -:::--------:/yy------------------/y/--/o------/-  ");                          
            $display("                    /:-----------:+y+:://:--------------+y--:o//:://-   ");                          
            $display("                   //--------------:-:+ssoo+/------------s--/. ````     ");                          
            $display("                   o---------:/:------dNNNmds+:----------/-//           ");                          
            $display("                   s--------/o+:------yNNNNNd/+--+y:------/+            ");                          
            $display("                 .-y---------o:-------:+sso+/-:-:yy:------o`            ");                          
            $display("              `:oosh/--------++-----------------:--:------/.            ");                          
            $display("              +ssssyy--------:y:---------------------------/            ");                          
            $display("              +ssssyd/--------/s/-------------++-----------/`           ");                          
            $display("              `/yyssyso/:------:+o/::----:::/+//:----------+`           ");                          
            $display("             ./osyyyysssso/------:/++o+++///:-------------/:            ");                          
            $display("           -osssssssssssssso/---------------------------:/.             ");                          
            $display("         `/sssshyssssssssssss+:---------------------:/+ss               ");                          
            $display("        ./ssssyysssssssssssssso:--------------:::/+syyys+               ");                          
            $display("     `-+sssssyssssssssssssssssso-----::/++ooooossyyssyy:                ");                          
            $display("     -syssssyssssssssssssssssssso::+ossssssssssssyyyyyss+`              ");                          
            $display("     .hsyssyssssssssssssssssssssyssssssssssyhhhdhhsssyssso`             ");                          
            $display("     +/yyshsssssssssssssssssssysssssssssyhhyyyyssssshysssso             ");                          
            $display("    ./-:+hsssssssssssssssssssssyyyyyssssssssssssssssshsssss:`           ");                          
            $display("    /---:hsyysyssssssssssssssssssssssssssssssssssssssshssssy+           ");                          
            $display("    o----oyy:-:/+oyysssssssssssssssssssssssssssssssssshssssy+-          ");                          
            $display("    s-----++-------/+sysssssssssssssssssssssssssssssyssssyo:-:-         ");                          
            $display("    o/----s-----------:+syyssssssssssssssssssssssyso:--os:----/.        ");                          
            $display("    `o/--:o---------------:+ossyysssssssssssyyso+:------o:-----:        ");                          
            $display("      /+:/+---------------------:/++ooooo++/:------------s:---::        ");                          
            $display("       `/o+----------------------------------------------:o---+`        ");                          
            $display("         `+-----------------------------------------------o::+.         ");                          
            $display("          +-----------------------------------------------/o/`          ");                          
            $display("          ::----------------------------------------------:-            ");
            repeat(5) @(negedge clk);
            $finish; 
        end
        exe_lat = exe_lat + 1;
        @(negedge clk);
    end
                   

end endtask

task check_task; begin
    // Check Output
    out_lat = 0;
    i = 0;
    j = 0;
    if ( mode==0 || mode==1 || mode==2 ) begin
        while ( out_valid === 1 ) begin
            if (out_lat==len*len) begin
                $display("                                                                                ");   
                $display("                                                   ./+oo+/.                     ");   
                $display("    Out cycles is more than %-2d                  /s:-----+s`     at %-12d ps   ", len*len, $time*1000);   
                $display("                                                  y/-------:y                   ");   
                $display("                                             `.-:/od+/------y`                  ");   
                $display("                               `:///+++ooooooo+//::::-----:/y+:`                ");   
                $display("                              -m+:::::::---------------------::o+.              ");   
                $display("                             `hod-------------------------------:o+             ");   
                $display("                       ./++/:s/-o/--------------------------------/s///::.      ");   
                $display("                      /s::-://--:--------------------------------:oo/::::o+     ");   
                $display("                    -+ho++++//hh:-------------------------------:s:-------+/    ");   
                $display("                  -s+shdh+::+hm+--------------------------------+/--------:s    ");   
                $display("                 -s:hMMMMNy---+y/-------------------------------:---------//    ");   
                $display("                 y:/NMMMMMN:---:s-/o:-------------------------------------+`    ");   
                $display("                 h--sdmmdy/-------:hyssoo++:----------------------------:/`     ");   
                $display("                 h---::::----------+oo+/::/+o:---------------------:+++s-`      ");   
                $display("                 s:----------------/s+///------------------------------o`       ");   
                $display("           ``..../s------------------::--------------------------------o        ");   
                $display("       -/oyhyyyyyym:----------------://////:--------------------------:/        ");   
                $display("      /dyssyyyssssyh:-------------/o+/::::/+o/------------------------+`        ");   
                $display("    -+o/---:/oyyssshd/-----------+o:--------:oo---------------------:/.         ");   
                $display("  `++--------:/sysssddy+:-------/+------------s/------------------://`          ");   
                $display(" .s:---------:+ooyysyyddoo++os-:s-------------/y----------------:++.            ");   
                $display(" s:------------/yyhssyshy:---/:o:-------------:dsoo++//:::::-::+syh`            ");   
                $display("`h--------------shyssssyyms+oyo:--------------/hyyyyyyyyyyyysyhyyyy`            ");   
                $display("`h--------------:yyssssyyhhyy+----------------+dyyyysssssssyyyhs+/.             ");   
                $display(" s:--------------/yysssssyhy:-----------------shyyyyyhyyssssyyh.                ");   
                $display(" .s---------------+sooosyyo------------------/yssssssyyyyssssyo                 ");   
                $display("  /+-------------------:++------------------:ysssssssssssssssy-                 ");   
                $display("  `s+--------------------------------------:syssssssssssssssyo                  ");   
                $display("`+yhdo--------------------:/--------------:syssssssssssssssyy.                  ");   
                $display("+yysyhh:-------------------+o------------/ysyssssssssssssssy/                   ");   
                $display(" /hhysyds:------------------y-----------/+yyssssssssssssssyh`                   ");   
                $display(" .h-+yysyds:---------------:s----------:--/yssssssssssssssym:                   ");   
                $display(" y/---oyyyyhyo:-----------:o:-------------:ysssssssssyyyssyyd-                  ");   
                $display("`h------+syyyyhhsoo+///+osh---------------:ysssyysyyyyysssssyd:                 ");   
                $display("/s--------:+syyyyyyyyyyyyyyhso/:-------::+oyyyyhyyyysssssssyy+-                 ");   
                $display("+s-----------:/osyyysssssssyyyyhyyyyyyyydhyyyyyyssssssssyys/`                   ");   
                $display("+s---------------:/osyyyysssssssssssssssyyhyyssssssyyyyso/y`                    ");   
                $display("/s--------------------:/+ossyyyyyyssssssssyyyyyyysso+:----:+                    ");   
                $display(".h--------------------------:::/++oooooooo+++/:::----------o`                   "); 
                repeat(5) @(negedge clk);
                $finish;
            end
            
            if ( i<len && j<len ) begin
                your[i][j] = out_data;
                if ( i<len )  j=j+1;
                if ( j==len ) begin
                    i=i+1;
                    j=0;
                end
            end                    
           
            out_lat = out_lat + 1;
            @(negedge clk);
        end
        
        if (out_lat<len*len) begin     
            $display("                                                                                ");   
            $display("                                                   ./+oo+/.                     ");   
            $display("    Out cycles is less than %-2d                  /s:-----+s`     at %-12d ps   ", len*len, $time*1000);   
            $display("                                                  y/-------:y                   ");   
            $display("                                             `.-:/od+/------y`                  ");   
            $display("                               `:///+++ooooooo+//::::-----:/y+:`                ");   
            $display("                              -m+:::::::---------------------::o+.              ");   
            $display("                             `hod-------------------------------:o+             ");   
            $display("                       ./++/:s/-o/--------------------------------/s///::.      ");   
            $display("                      /s::-://--:--------------------------------:oo/::::o+     ");   
            $display("                    -+ho++++//hh:-------------------------------:s:-------+/    ");   
            $display("                  -s+shdh+::+hm+--------------------------------+/--------:s    ");   
            $display("                 -s:hMMMMNy---+y/-------------------------------:---------//    ");   
            $display("                 y:/NMMMMMN:---:s-/o:-------------------------------------+`    ");   
            $display("                 h--sdmmdy/-------:hyssoo++:----------------------------:/`     ");   
            $display("                 h---::::----------+oo+/::/+o:---------------------:+++s-`      ");   
            $display("                 s:----------------/s+///------------------------------o`       ");   
            $display("           ``..../s------------------::--------------------------------o        ");   
            $display("       -/oyhyyyyyym:----------------://////:--------------------------:/        ");   
            $display("      /dyssyyyssssyh:-------------/o+/::::/+o/------------------------+`        ");   
            $display("    -+o/---:/oyyssshd/-----------+o:--------:oo---------------------:/.         ");   
            $display("  `++--------:/sysssddy+:-------/+------------s/------------------://`          ");   
            $display(" .s:---------:+ooyysyyddoo++os-:s-------------/y----------------:++.            ");   
            $display(" s:------------/yyhssyshy:---/:o:-------------:dsoo++//:::::-::+syh`            ");   
            $display("`h--------------shyssssyyms+oyo:--------------/hyyyyyyyyyyyysyhyyyy`            ");   
            $display("`h--------------:yyssssyyhhyy+----------------+dyyyysssssssyyyhs+/.             ");   
            $display(" s:--------------/yysssssyhy:-----------------shyyyyyhyyssssyyh.                ");   
            $display(" .s---------------+sooosyyo------------------/yssssssyyyyssssyo                 ");   
            $display("  /+-------------------:++------------------:ysssssssssssssssy-                 ");   
            $display("  `s+--------------------------------------:syssssssssssssssyo                  ");   
            $display("`+yhdo--------------------:/--------------:syssssssssssssssyy.                  ");   
            $display("+yysyhh:-------------------+o------------/ysyssssssssssssssy/                   ");   
            $display(" /hhysyds:------------------y-----------/+yyssssssssssssssyh`                   ");   
            $display(" .h-+yysyds:---------------:s----------:--/yssssssssssssssym:                   ");   
            $display(" y/---oyyyyhyo:-----------:o:-------------:ysssssssssyyyssyyd-                  ");   
            $display("`h------+syyyyhhsoo+///+osh---------------:ysssyysyyyyysssssyd:                 ");   
            $display("/s--------:+syyyyyyyyyyyyyyhso/:-------::+oyyyyhyyyysssssssyy+-                 ");   
            $display("+s-----------:/osyyysssssssyyyyhyyyyyyyydhyyyyyyssssssssyys/`                   ");   
            $display("+s---------------:/osyyyysssssssssssssssyyhyyssssssyyyyso/y`                    ");   
            $display("/s--------------------:/+ossyyyyyyssssssssyyyyyyysso+:----:+                    ");   
            $display(".h--------------------------:::/++oooooooo+++/:::----------o`                   "); 
            repeat(5) @(negedge clk);
            $finish;
        end
        
        for ( i=0 ; i<len ; i=i+1 ) begin
            for ( j=0 ; j<len ; j=j+1 ) begin
                if ( your[i][j] !== gold[i][j] ) begin
                    $display("...`...`....````````````````````````````````````````````````````...`````................   ");
                    $display("................`````.```````````````````````````````````````````````.`...`................");
                    $display(".............-/:.`.``````````````````````````````````````-///+++//+/-```...................");
                    $display("..........```o::++/.```````````````````````````````````:o/::::::::::++.``..................");
                    $display("............`o:-.`.::-``````````````````.:-```````````/+:::::::::::::/o``..................");
                    $display("...........``o:.`````-/-`````````````-:/::/``````````.s/::::::::::::::y```.`...............");
                    $display(".........```.:/-```````-/.````````.--``-:/```````````.y+/::::::::::::/o```````.............");
                    $display("......`.....`.+:.````````:/.```...``` .::`````````````-+::::::::::::/o.```.`...............");
                    $display(".........````..o:.`````````/-.-.``` `-/-```````````.:/++o+++///+osso/```````..``..`........");
                    $display(".....`...```.``.o/:.````````-. `` `-/:..:::/+//++///::::::::::::::/+so/.```.``...`.........");
                    $display("....```````````.o-.``````---   `.:/:..+ssoo+/:::::::::::::::::::::::://+o-.`..-/////++:....");
                    $display("...`````````````//```:+o-  -:-///-```-o::::::::::::::::::::::::::::::::::o+.-o+:::::::+o-..");
                    $display("...``````````````.:oyh+.`-/ohNh+:-.``:+os///::::::::::::::::::::::::::::::/yo:::::::::::s..");
                    $display("...``````````````.hyyo/::--dNNNNy//++oyMN/o::::::::/os:::::::::::::::::::::s:::::::::::://.");
                    $display("...`.`````````````--``````oNmmmmN/::::://+/::::::::::ss:::::::::::::::::::o/::::::::::::/+`");
                    $display("...`.````````````````````.sNNmmNm:::::::::::::::::::::y/::::::::::::::::::o:::::::::::::+:`");
                    $display("...``````````````````````++ohys+:::::::::::::::ohy::::s/::::::::::::::::::o+:::::::::::/o`.");
                    $display("...``Your matrix`````````o/:::::::::::::::::::oMNs::::/::::::::::::::::::::/:::::::::/o/``.");
                    $display("...``````````````````````/+::::::::::::::::::::/:::::::::::::::::::::::::::://///++++:.`...");
                    $display("...```is incorrect!!````.s::::::::::::::::::::::::::::::::::::::::::::::::::::h/..`````.``");
                    $display("...```````````````````````os::::::::::::::::::::::::::::::::::::::::::::::::::/y.``````````");
                    $display("...```````````````````````/++:::::::::::::::::::::::::::::::::::::::::::::::::h-```.```````");
                    $display("...````````````````````````o/++:::::::::/ss/:::::::::::::::::::::::::::::::::h:.``````````.");
                    $display("...````````````````````````-o::++++/::/++//o/::::::::::::::::::::::::::::::/o-`..``.`.```..");
                    $display("...`````````````````````````-o:::::/++/:::::::::::::::::::::::::::::::::::/o..`````..`.``..");
                    $display("...``````````````````````````.+/:::::::::::::::::::::::::::::::::::::::::+o..```...........");
                    $display("...````````````````````````````:o::::::::::::::::::::::::::::::::::::::::dy:.......`.``....");
                    $display("...`````````````````````````````.o+::::::::::::::::::::::::::::::::::::/yhhds..............");
                    $display("...```````````````````````````````+y/::::::::::::::::::::::::://+oosyhhhhhdy-....`....`....");
                    $display("...``````````````````````````````-hyhs/::::::::::::::::/+osyyhhhyyyyyyyyyds.`....`.........");
                    $display("...`````````````````````````````-ydyyyh+++//::::::/+oyhhhhyyyyyyyyyyyyyyyh`................");
                    $display("...````````````````````````````-hhhyyyh::::/ooyhhhdhhhyyyyyyyyyyyyhyyyyyyho................");
                    $display("...``````````````````````````-ohydyyyyd//oshdhhhhhyyyyyyyyyyyyyyhhyyyyyyyyhs:..............");
                    $display("...````````````````````````-hhdyyhyyyyyhhyhyhyyyyyyyyyyyyyyyyyhhyyyyyyyyyyyhh+.............");
                    $display("...````````````````````.://dhydyhhyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyyyyyyyyyhhy-...........");
                    $display("...```````````````-//+++/:/dhyhddyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyyyyyyyyyyyyhh/..........");
                    $display("...``````````.://+/::::::::dhyydyyyyyyyyyyyyyyyyyyyyyyyhyyyhyyyyyyyyyyyyyyhhhhhhds-........");
                    $display("...``````.:///:::::::::::::shhdyyyyyyyyyyyyyyyyyyyyyyyyhyyhhyyyyyyyyyyyhhhhhhyyyhhhy:......");
                    $display("...````-++//::::::::::::::/hhyhhhhhyyyyyyyyyyyyyyyyyyyyhyydyyyyyyyyyhhhyyhhyyyyyyyyyh+.....");
                    $display("...``-o+/o/::::::::::::::shyyyyyyyyhhhhyyyyhyyyyyyyyyyyhyydyyyyyyyyhhyyyhyyyhyyyyyyyhh:....");
                    $display("...`-o:/o:::::o/::::::::hhyyyyyyyyyyyyyyhhhhyhhhhyyyyyyyyyhyyyyyyyhyyhhhyysso+//:::::oy....");
                    $display("...`o/:/o::::oo:::::::::+hyosyyyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyhyyhhyyo//:::::::::::o+...");
                    $display("...`/o:::++++:::::::::::oo::::/++osyyyyyyyyyyyyyyyyyyyyyyyyyyyyyydyyhyss/:::::::::::::/y...");
                    $display("...`.s+::::::::::::/+++yo:::::::::::+osyhyyyyyyyyyyyyyyyyyhhhhyyyhyhhy/::::::::::::::::++..");
                    $display("...``.++::::::/++/::-.o+:::::::::::::::::+osyhyyyyyyyyyyyyyyyhhhhdds+:::::::::::::::::::o`.");
                    $display("Your output is not correct", pat);
    
                    $display("Your matrix:");
                    for ( i=0 ; i<len ; i=i+1 ) begin
                        for ( j=0 ; j<len ; j=j+1 ) begin
                            if ( your[i][j] != gold[i][j] )
                                $write( "\033[1;31m%d \033[1;0m", your[i][j] );
                            else
                                $write( "%d ", your[i][j] );
    
                        end
                        $display( " " );
                    end
                    
                    $display("Golden matrix:");
                    for ( i=0 ; i<len ; i=i+1 ) begin
                        for ( j=0 ; j<len ; j=j+1 ) begin
                            if ( your[i][j] != gold[i][j] )
                                $write( "\033[1;31m%d \033[1;0m", gold[i][j] );
                            else
                                $write( "%d ", gold[i][j] );
                        end
                        $display( " " );
                    end
    
                    repeat(5) @(negedge clk);
                    $finish;
                end
            end
        end
    end
    else begin
        while ( out_valid === 1 ) begin
            if (out_lat==1) begin
                $display("                                                                                ");   
                $display("                                                   ./+oo+/.                     ");   
                $display("    Out cycles is more than %-2d                  /s:-----+s`     at %-12d ps   ", len*len, $time*1000);   
                $display("                                                  y/-------:y                   ");   
                $display("                                             `.-:/od+/------y`                  ");   
                $display("                               `:///+++ooooooo+//::::-----:/y+:`                ");   
                $display("                              -m+:::::::---------------------::o+.              ");   
                $display("                             `hod-------------------------------:o+             ");   
                $display("                       ./++/:s/-o/--------------------------------/s///::.      ");   
                $display("                      /s::-://--:--------------------------------:oo/::::o+     ");   
                $display("                    -+ho++++//hh:-------------------------------:s:-------+/    ");   
                $display("                  -s+shdh+::+hm+--------------------------------+/--------:s    ");   
                $display("                 -s:hMMMMNy---+y/-------------------------------:---------//    ");   
                $display("                 y:/NMMMMMN:---:s-/o:-------------------------------------+`    ");   
                $display("                 h--sdmmdy/-------:hyssoo++:----------------------------:/`     ");   
                $display("                 h---::::----------+oo+/::/+o:---------------------:+++s-`      ");   
                $display("                 s:----------------/s+///------------------------------o`       ");   
                $display("           ``..../s------------------::--------------------------------o        ");   
                $display("       -/oyhyyyyyym:----------------://////:--------------------------:/        ");   
                $display("      /dyssyyyssssyh:-------------/o+/::::/+o/------------------------+`        ");   
                $display("    -+o/---:/oyyssshd/-----------+o:--------:oo---------------------:/.         ");   
                $display("  `++--------:/sysssddy+:-------/+------------s/------------------://`          ");   
                $display(" .s:---------:+ooyysyyddoo++os-:s-------------/y----------------:++.            ");   
                $display(" s:------------/yyhssyshy:---/:o:-------------:dsoo++//:::::-::+syh`            ");   
                $display("`h--------------shyssssyyms+oyo:--------------/hyyyyyyyyyyyysyhyyyy`            ");   
                $display("`h--------------:yyssssyyhhyy+----------------+dyyyysssssssyyyhs+/.             ");   
                $display(" s:--------------/yysssssyhy:-----------------shyyyyyhyyssssyyh.                ");   
                $display(" .s---------------+sooosyyo------------------/yssssssyyyyssssyo                 ");   
                $display("  /+-------------------:++------------------:ysssssssssssssssy-                 ");   
                $display("  `s+--------------------------------------:syssssssssssssssyo                  ");   
                $display("`+yhdo--------------------:/--------------:syssssssssssssssyy.                  ");   
                $display("+yysyhh:-------------------+o------------/ysyssssssssssssssy/                   ");   
                $display(" /hhysyds:------------------y-----------/+yyssssssssssssssyh`                   ");   
                $display(" .h-+yysyds:---------------:s----------:--/yssssssssssssssym:                   ");   
                $display(" y/---oyyyyhyo:-----------:o:-------------:ysssssssssyyyssyyd-                  ");   
                $display("`h------+syyyyhhsoo+///+osh---------------:ysssyysyyyyysssssyd:                 ");   
                $display("/s--------:+syyyyyyyyyyyyyyhso/:-------::+oyyyyhyyyysssssssyy+-                 ");   
                $display("+s-----------:/osyyysssssssyyyyhyyyyyyyydhyyyyyyssssssssyys/`                   ");   
                $display("+s---------------:/osyyyysssssssssssssssyyhyyssssssyyyyso/y`                    ");   
                $display("/s--------------------:/+ossyyyyyyssssssssyyyyyyysso+:----:+                    ");   
                $display(".h--------------------------:::/++oooooooo+++/:::----------o`                   "); 
                repeat(5) @(negedge clk);
                $finish;
            end
            if ( out_data!=0 ) begin
                $display("...`...`....````````````````````````````````````````````````````...`````................   ");
                $display("................`````.```````````````````````````````````````````````.`...`................");
                $display(".............-/:.`.``````````````````````````````````````-///+++//+/-```...................");
                $display("..........```o::++/.```````````````````````````````````:o/::::::::::++.``..................");
                $display("............`o:-.`.::-``````````````````.:-```````````/+:::::::::::::/o``..................");
                $display("...........``o:.`````-/-`````````````-:/::/``````````.s/::::::::::::::y```.`...............");
                $display(".........```.:/-```````-/.````````.--``-:/```````````.y+/::::::::::::/o```````.............");
                $display("......`.....`.+:.````````:/.```...``` .::`````````````-+::::::::::::/o.```.`...............");
                $display(".........````..o:.`````````/-.-.``` `-/-```````````.:/++o+++///+osso/```````..``..`........");
                $display(".....`...```.``.o/:.````````-. `` `-/:..:::/+//++///::::::::::::::/+so/.```.``...`.........");
                $display("....```````````.o-.``````---   `.:/:..+ssoo+/:::::::::::::::::::::::://+o-.`..-/////++:....");
                $display("...`````````````//```:+o-  -:-///-```-o::::::::::::::::::::::::::::::::::o+.-o+:::::::+o-..");
                $display("...``````````````.:oyh+.`-/ohNh+:-.``:+os///::::::::::::::::::::::::::::::/yo:::::::::::s..");
                $display("...``````````````.hyyo/::--dNNNNy//++oyMN/o::::::::/os:::::::::::::::::::::s:::::::::::://.");
                $display("...`.`````````````--``````oNmmmmN/::::://+/::::::::::ss:::::::::::::::::::o/::::::::::::/+`");
                $display("...`.````````````````````.sNNmmNm:::::::::::::::::::::y/::::::::::::::::::o:::::::::::::+:`");
                $display("...``````````````````````++ohys+:::::::::::::::ohy::::s/::::::::::::::::::o+:::::::::::/o`.");
                $display("...``Your output`````````o/:::::::::::::::::::oMNs::::/::::::::::::::::::::/:::::::::/o/``.");
                $display("...``````````````````````/+::::::::::::::::::::/:::::::::::::::::::::::::::://///++++:.`...");
                $display("...```is incorrect!!````.s::::::::::::::::::::::::::::::::::::::::::::::::::::h/..`````.``");
                $display("...```````````````````````os::::::::::::::::::::::::::::::::::::::::::::::::::/y.``````````");
                $display("...```````````````````````/++:::::::::::::::::::::::::::::::::::::::::::::::::h-```.```````");
                $display("...````````````````````````o/++:::::::::/ss/:::::::::::::::::::::::::::::::::h:.``````````.");
                $display("...````````````````````````-o::++++/::/++//o/::::::::::::::::::::::::::::::/o-`..``.`.```..");
                $display("...`````````````````````````-o:::::/++/:::::::::::::::::::::::::::::::::::/o..`````..`.``..");
                $display("...``````````````````````````.+/:::::::::::::::::::::::::::::::::::::::::+o..```...........");
                $display("...````````````````````````````:o::::::::::::::::::::::::::::::::::::::::dy:.......`.``....");
                $display("...`````````````````````````````.o+::::::::::::::::::::::::::::::::::::/yhhds..............");
                $display("...```````````````````````````````+y/::::::::::::::::::::::::://+oosyhhhhhdy-....`....`....");
                $display("...``````````````````````````````-hyhs/::::::::::::::::/+osyyhhhyyyyyyyyyds.`....`.........");
                $display("...`````````````````````````````-ydyyyh+++//::::::/+oyhhhhyyyyyyyyyyyyyyyh`................");
                $display("...````````````````````````````-hhhyyyh::::/ooyhhhdhhhyyyyyyyyyyyyhyyyyyyho................");
                $display("...``````````````````````````-ohydyyyyd//oshdhhhhhyyyyyyyyyyyyyyhhyyyyyyyyhs:..............");
                $display("...````````````````````````-hhdyyhyyyyyhhyhyhyyyyyyyyyyyyyyyyyhhyyyyyyyyyyyhh+.............");
                $display("...````````````````````.://dhydyhhyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyyyyyyyyyhhy-...........");
                $display("...```````````````-//+++/:/dhyhddyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyyyyyyyyyyyyhh/..........");
                $display("...``````````.://+/::::::::dhyydyyyyyyyyyyyyyyyyyyyyyyyhyyyhyyyyyyyyyyyyyyhhhhhhds-........");
                $display("...``````.:///:::::::::::::shhdyyyyyyyyyyyyyyyyyyyyyyyyhyyhhyyyyyyyyyyyhhhhhhyyyhhhy:......");
                $display("...````-++//::::::::::::::/hhyhhhhhyyyyyyyyyyyyyyyyyyyyhyydyyyyyyyyyhhhyyhhyyyyyyyyyh+.....");
                $display("...``-o+/o/::::::::::::::shyyyyyyyyhhhhyyyyhyyyyyyyyyyyhyydyyyyyyyyhhyyyhyyyhyyyyyyyhh:....");
                $display("...`-o:/o:::::o/::::::::hhyyyyyyyyyyyyyyhhhhyhhhhyyyyyyyyyhyyyyyyyhyyhhhyysso+//:::::oy....");
                $display("...`o/:/o::::oo:::::::::+hyosyyyyyyyyyyyyyyyyyyyyyyyyyyyyyhyyyyyyhyyhhyyo//:::::::::::o+...");
                $display("...`/o:::++++:::::::::::oo::::/++osyyyyyyyyyyyyyyyyyyyyyyyyyyyyyydyyhyss/:::::::::::::/y...");
                $display("...`.s+::::::::::::/+++yo:::::::::::+osyhyyyyyyyyyyyyyyyyyhhhhyyyhyhhy/::::::::::::::::++..");
                $display("...``.++::::::/++/::-.o+:::::::::::::::::+osyhyyyyyyyyyyyyyyyhhhhdds+:::::::::::::::::::o`.");
                repeat(5) @(negedge clk);
                $finish;
            end
            out_lat = out_lat + 1;
            @(negedge clk);
        end
    end
    $display("\033[1;35mPATTERN \033[1;34m%-5d PASS!!!\033[1;0m", pat, exe_lat);

end endtask

task pass_task; begin
    $display("\033[1;33m                `oo+oy+`                            \033[1;35m Congratulation!!! \033[1;0m                                   ");
    $display("\033[1;33m               /h/----+y        `+++++:             \033[1;35m PASS This Lab........Maybe \033[1;0m                          ");
    $display("\033[1;33m             .y------:m/+ydoo+:y:---:+o                                                                                      ");
    $display("\033[1;33m              o+------/y--::::::+oso+:/y                                                                                     ");
    $display("\033[1;33m              s/-----:/:----------:+ooy+-                                                                                    ");
    $display("\033[1;33m             /o----------------/yhyo/::/o+/:-.`                                                                              ");
    $display("\033[1;33m            `ys----------------:::--------:::+yyo+                                                                           ");
    $display("\033[1;33m            .d/:-------------------:--------/--/hos/                                                                         ");
    $display("\033[1;33m            y/-------------------::ds------:s:/-:sy-                                                                         ");
    $display("\033[1;33m           +y--------------------::os:-----:ssm/o+`                                                                          ");
    $display("\033[1;33m          `d:-----------------------:-----/+o++yNNmms                                                                        ");
    $display("\033[1;33m           /y-----------------------------------hMMMMN.                                                                      ");
    $display("\033[1;33m           o+---------------------://:----------:odmdy/+.                                                                    ");
    $display("\033[1;33m           o+---------------------::y:------------::+o-/h                                                                    ");
    $display("\033[1;33m           :y-----------------------+s:------------/h:-:d                                                                    ");
    $display("\033[1;33m           `m/-----------------------+y/---------:oy:--/y                                                                    ");
    $display("\033[1;33m            /h------------------------:os++/:::/+o/:--:h-                                                                    ");
    $display("\033[1;33m         `:+ym--------------------------://++++o/:---:h/                                                                     ");
    $display("\033[1;31m        `hhhhhoooo++oo+/:\033[1;33m--------------------:oo----\033[1;31m+dd+                                                 ");
    $display("\033[1;31m         shyyyhhhhhhhhhhhso/:\033[1;33m---------------:+/---\033[1;31m/ydyyhs:`                                              ");
    $display("\033[1;31m         .mhyyyyyyhhhdddhhhhhs+:\033[1;33m----------------\033[1;31m:sdmhyyyyyyo:                                            ");
    $display("\033[1;31m        `hhdhhyyyyhhhhhddddhyyyyyo++/:\033[1;33m--------\033[1;31m:odmyhmhhyyyyhy                                            ");
    $display("\033[1;31m        -dyyhhyyyyyyhdhyhhddhhyyyyyhhhs+/::\033[1;33m-\033[1;31m:ohdmhdhhhdmdhdmy:                                           ");
    $display("\033[1;31m         hhdhyyyyyyyyyddyyyyhdddhhyyyyyhhhyyhdhdyyhyys+ossyhssy:-`                                                           ");
    $display("\033[1;31m         `Ndyyyyyyyyyyymdyyyyyyyhddddhhhyhhhhhhhhy+/:\033[1;33m-------::/+o++++-`                                            ");
    $display("\033[1;31m          dyyyyyyyyyyyyhNyydyyyyyyyyyyhhhhyyhhy+/\033[1;33m------------------:/ooo:`                                         ");
    $display("\033[1;31m         :myyyyyyyyyyyyyNyhmhhhyyyyyhdhyyyhho/\033[1;33m-------------------------:+o/`                                       ");
    $display("\033[1;31m        /dyyyyyyyyyyyyyyddmmhyyyyyyhhyyyhh+:\033[1;33m-----------------------------:+s-                                      ");
    $display("\033[1;31m      +dyyyyyyyyyyyyyyydmyyyyyyyyyyyyyds:\033[1;33m---------------------------------:s+                                      ");
    $display("\033[1;31m      -ddhhyyyyyyyyyyyyyddyyyyyyyyyyyhd+\033[1;33m------------------------------------:oo              `-++o+:.`             ");
    $display("\033[1;31m       `/dhshdhyyyyyyyyyhdyyyyyyyyyydh:\033[1;33m---------------------------------------s/            -o/://:/+s             ");
    $display("\033[1;31m         os-:/oyhhhhyyyydhyyyyyyyyyds:\033[1;33m----------------------------------------:h:--.`      `y:------+os            ");
    $display("\033[1;33m         h+-----\033[1;31m:/+oosshdyyyyyyyyhds\033[1;33m-------------------------------------------+h//o+s+-.` :o-------s/y  ");
    $display("\033[1;33m         m:------------\033[1;31mdyyyyyyyyymo\033[1;33m--------------------------------------------oh----:://++oo------:s/d  ");
    $display("\033[1;33m        `N/-----------+\033[1;31mmyyyyyyyydo\033[1;33m---------------------------------------------sy---------:/s------+o/d  ");
    $display("\033[1;33m        .m-----------:d\033[1;31mhhyyyyyyd+\033[1;33m----------------------------------------------y+-----------+:-----oo/h  ");
    $display("\033[1;33m        +s-----------+N\033[1;31mhmyyyyhd/\033[1;33m----------------------------------------------:h:-----------::-----+o/m  ");
    $display("\033[1;33m        h/----------:d/\033[1;31mmmhyyhh:\033[1;33m-----------------------------------------------oo-------------------+o/h  ");
    $display("\033[1;33m       `y-----------so /\033[1;31mNhydh:\033[1;33m-----------------------------------------------/h:-------------------:soo  ");
    $display("\033[1;33m    `.:+o:---------+h   \033[1;31mmddhhh/:\033[1;33m---------------:/osssssoo+/::---------------+d+//++///::+++//::::::/y+`  ");
    $display("\033[1;33m   -s+/::/--------+d.   \033[1;31mohso+/+y/:\033[1;33m-----------:yo+/:-----:/oooo/:----------:+s//::-.....--:://////+/:`    ");
    $display("\033[1;33m   s/------------/y`           `/oo:--------:y/-------------:/oo+:------:/s:                                                 ");
    $display("\033[1;33m   o+:--------::++`              `:so/:-----s+-----------------:oy+:--:+s/``````                                             ");
    $display("\033[1;33m    :+o++///+oo/.                   .+o+::--os-------------------:oy+oo:`/o+++++o-                                           ");
    $display("\033[1;33m       .---.`                          -+oo/:yo:-------------------:oy-:h/:---:+oyo                                          ");
    $display("\033[1;33m                                          `:+omy/---------------------+h:----:y+//so                                         ");
    $display("\033[1;33m                                              `-ys:-------------------+s-----+s///om                                         ");
    $display("\033[1;33m                                                 -os+::---------------/y-----ho///om                                         ");
    $display("\033[1;33m                                                    -+oo//:-----------:h-----h+///+d                                         ");
    $display("\033[1;33m                                                       `-oyy+:---------s:----s/////y                                         ");
    $display("\033[1;33m                                                           `-/o+::-----:+----oo///+s                                         ");
    $display("\033[1;33m                                                               ./+o+::-------:y///s:                                         ");
    $display("\033[1;33m                                                                   ./+oo/-----oo/+h                                          ");
    $display("\033[1;33m                                                                       `://++++syo`                                          ");
    $display("\033[1;0m"); 
    repeat(5) @(negedge clk);
    $finish;

end endtask

task display_task; begin
    for ( i=0 ; i<len ; i=i+1 ) begin
        for ( j=0 ; j<len ; j=j+1 ) begin
            $write( "%d ", gold[i][j] );
        end
        $display( " " );
    end
end endtask

endmodule


