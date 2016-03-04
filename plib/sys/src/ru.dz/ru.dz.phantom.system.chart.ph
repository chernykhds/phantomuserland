/**
 *
 * Phantom OS - Phantom language library
 *
 * Copyright (C) 2005-2009 Dmitry Zavalishin, dz@dz.ru
 *
 * Simple chart
 *
 *
**/

package .ru.dz.phantom.system;

import .phantom.os;
import .internal.io.tty;
import .internal.window;
import .internal.connection;
import .ru.dz.phantom.system.runnable;

attribute const * ->!;


class chart //extends runnable
{
    var stat_val :  int;
    var stat_pos :  int;
    var stat_next_pos :  int;

    var cpu_idle : int;
    var old_idle : int;

    var white : int;

    var win : .internal.window;
    var timer : .internal.connection;

    //var fio : .internal.connection;

    var stat_conn : .internal.connection;


    //var mtx : .internal.mutex;


    void init()
    {
        //mtx = new .internal.mutex();
        //mtx.lock();
    }

    void go()
    {
        //mtx.unlock();
    }

    void run(var parent_object @const ) [8]
    {

        win = new .internal.window();

        win.setWinPosition(50,310);
        win.setTitle("Disk io stats");
        win.setFg(0xFF000000); // black

        win.clear();
        win.update();

        stat_pos = 0;
        old_idle = 0;

        white = 0xFFFFFFFF;


		// test of fio connection
		//fio = new .internal.connection();
        //fio.connect("fio:/amnt1/fio_log.txt");
		//fio.block("written from phantom code", 1);

        // test of connections
        timer = new .internal.connection();
        timer.connect("tmr:");


        stat_conn = new .internal.connection();
        stat_conn.connect("stt:");

        while(1)
        {

            timer.block(null, 500);
            stat_val = stat_conn.block( 26, 0 ); // blk io per sec
            cpu_idle = stat_conn.block( 0, 5 ); // cpu 0 idle

            cpu_idle = 100 - cpu_idle;

            stat_next_pos = stat_pos + 1;
            if( stat_next_pos >= win.getXSize() )
                stat_next_pos = 0;

            // Bar
            win.setFg( 0xFF00FF00 ); // Green
            win.drawLine( stat_next_pos, 5, 0, 300 );

            // Clear
            win.setFg( white ); // white
            win.drawLine( stat_pos, 5, 0, 300 );

            win.setFg(0xFF000000); // black
            win.drawLine( stat_pos, 5, 0, 0+stat_val );

            // Idle
            win.setFg( 0xFF0000FF ); // Blue
            win.drawLine( stat_pos-1, old_idle, 1, cpu_idle-old_idle );

            old_idle = cpu_idle;            
            stat_pos = stat_next_pos;
            
            /*
            if( stat_pos >= win.getXSize()-1 )
	        win.scrollHor( 0, 0, win.getXSize(), win.getYSize(), 0-1 );
            else
                stat_pos = stat_pos + 1;
            */

            win.update();


        }


    }
};

