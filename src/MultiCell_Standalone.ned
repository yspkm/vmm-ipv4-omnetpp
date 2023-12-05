// 
//                  Simu5G
//
// Authors: Giovanni Nardini, Giovanni Stea, Antonio Virdis (University of Pisa)
// 
// This file is part of a software released under the license included in file
// "license.pdf". Please read LICENSE and README files before using it.
// The above files and the present reference are part of the software itself, 
// and cannot be removed from it.
// 
package simu5g.simulations.NR.networks;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.ethernet.Eth10G;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import simu5g.common.binder.Binder;
import simu5g.common.carrierAggregation.CarrierAggregation;
import simu5g.nodes.Upf;
import simu5g.nodes.NR.gNodeB;
import simu5g.nodes.NR.NRUe;
import simu5g.nodes.backgroundCell.BackgroundCell;
import simu5g.world.radio.LteChannelControl;

// MultiCell_standalone
//
// This network represents the deployment option 3 in 3GPP 38.801
//
network MultiCell_Standalone
{
    parameters:
        int numUe = default(10); // up to 10
        int numBgCells = default(1);
    submodules:
        channelControl: LteChannelControl {
            @display("p=50,25;is=s");
        }
        routingRecorder: RoutingTableRecorder {
            @display("p=50,75;is=s");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=50,125");
        }
        binder: Binder {
            @display("p=50,175;is=s");
        }
        carrierAggregation: CarrierAggregation {
            @display("p=50.993748,258.7;is=s");
        }
        server: StandardHost {
            @display("p=212,118;is=n;i=device/server");
        }
        router: Router {
            @display("p=351.81198,115.771996;i=device/smallrouter");
        }
        upf: Upf {
            @display("p=500,115");
        }
        iUpf: Upf {
            @display("p=500,215");
        }

        gnb1: gNodeB {
            @display("p=256.62,285.285;is=vl");
        }
        gnb2: gNodeB {
            @display("p=331.695,521.43;is=vl");
        }
        gnb3: gNodeB {
            @display("p=769.86,550.095;is=vl");
        }
        gnb4: gNodeB {
            @display("p=900.89996,308.49;is=vl");
        }
        gnb5: gNodeB {
            @display("p=794.43,91.454994;is=vl");
        }
        ue[numUe]: NRUe {
            @display("p=random");
        }

        bgCell[numBgCells]: BackgroundCell {
            @display("p=111.93,539.175;is=vl");
        }


    connections:

        //# Data Network connections
        server.pppg++ <--> Eth10G <--> router.pppg++;
        router.pppg++ <--> Eth10G <--> upf.filterGate;

        //# 5G Core Network connections
        upf.pppg++ <--> Eth10G <--> iUpf.pppg++;
        iUpf.pppg++ <--> Eth10G <--> gnb1.ppp;
        iUpf.pppg++ <--> Eth10G <--> gnb2.ppp;
        iUpf.pppg++ <--> Eth10G <--> gnb3.ppp; //# midterm
        iUpf.pppg++ <--> Eth10G <--> gnb4.ppp; //# midterm
        iUpf.pppg++ <--> Eth10G <--> gnb5.ppp; //# midterm

        //# X2 connections
        gnb1.x2++ <--> Eth10G <--> gnb2.x2++;
        gnb2.x2++ <--> Eth10G <--> gnb3.x2++; //# midterm 
        gnb3.x2++ <--> Eth10G <--> gnb4.x2++; //# midterm
        gnb4.x2++ <--> Eth10G <--> gnb5.x2++; //# midterm
}
