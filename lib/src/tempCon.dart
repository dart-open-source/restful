


String tempCli='''
#!/bin/bash
#head#
case "\$1" in
    start)
        dart lib/app.dart start
        ;;
    stop)
        dart lib/app.dart stop
        ;;
    run)
        nohup dart lib/app.dart "\$2" > "res/app-\$3.log" 2>&1 &
        ;;
    status)
        dart lib/app.dart status
        ;;
    restart)
        \$0 stop
        sleep 1
        \$0 start
        sleep 1
        \$0 status
        ;;
    -v)
        echo "dart author:almpazel@gmail.com , version:1.0.0"
        ;;
    *)
        echo "Please use start, stop, restart or status as first argument or [-v]"
        ;;
esac

''';