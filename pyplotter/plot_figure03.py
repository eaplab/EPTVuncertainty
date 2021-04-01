# -*- coding: utf-8 -*-
"""
Created on Tue Dec 8 20:26:24 2020

@author: aguemes
"""

import sys
import matplotlib
import numpy as np
sys.path.insert(1, '/Users/aguemes/tools/TheArtist')
import scipy.io as sio
from artist import TheArtist


def main():
    """
        Main execution logic
    """

    """
        Load data
    """

    # Load DNS data

    data_dns_gt = sio.loadmat('../output/DNS_Win1-3-199_S1400_it100.mat')
    data_dns    = sio.loadmat('../output/DNS_Win1-3-199_S1400_it100_PP_profile.mat')
    WS1 = data_dns_gt['RetauGT'][0]*1.3/700
    W = data_dns_gt['Win'][0,:] * WS1
    
    # Defining colors

    cmap = matplotlib.cm.get_cmap('inferno')
    color_dns        = cmap(0.2)
    color_nagib      = cmap(0.6)

    """
        Generate figure
    """
    
    # Initialize plotting environment
    Figure03 = TheArtist()
    # Generate figure environment
    Figure03.generate_figure_environment(cols=2, rows=3, fig_width_pt=487.82, ratio='golden', regular=True)

    """
        Plot DNS data
    """
    
    # Plot displacement thickness

    Figure03.plot_lines(
        W, 
        (data_dns['med'][0,0][2][0,:] - data_dns_gt['dsGT'][0,0]) / data_dns_gt['dsGT'][0,0] * 100,
        0, 
        0, 
        linestyle='-',
        color=color_dns
    )
    
    # Plot momentum thickness

    Figure03.plot_lines(
        W, 
        (data_dns['med'][0,0][3][0,:] - data_dns_gt['thetaGT'][0,0]) / data_dns_gt['thetaGT'][0,0] * 100,
        1, 
        0, 
        linestyle='-',
        color=color_dns
    )

    # # Plot boundary layer thickness thickness

    Figure03.plot_lines(
        W, 
        (data_dns['med'][0,0][4][0,:] - data_dns_gt['D99GT'][0,0]) / data_dns_gt['D99GT'][0,0] * 100,
        2, 
        0, 
        linestyle='-',
        color=color_dns
    )
    
    # Plot friction velocty

    Figure03.plot_lines(
        W, 
        (data_dns['med'][0,0][7][0,:] - data_dns_gt['UTAUGT'][0,0]) / data_dns_gt['UTAUGT'][0,0] * 100,
        0, 
        1, 
        linestyle='-',
        color=color_dns
    )
    
    # Plot freestream velocity

    Figure03.plot_lines(
        W, 
        (data_dns['med'][0,0][8][0,:] - data_dns_gt['UINFGT'][0,0]) / data_dns_gt['UINFGT'][0,0] * 100,
        1, 
        1, 
        linestyle='-',
        color=color_dns
    )

    # Plot delta y
  
    Figure03.plot_lines(
        W, 
        (data_dns['med'][0,0][10][0,:] - data_dns_gt['DYwuGT'][0,0]),
        2, 
        1, 
        linestyle='-',
        color=color_dns
    )

    """
        Plot Nagib data
    """

    # Load nagib data

    data_nagib_gt = sio.loadmat('../output/CP_Win1-3-199_S1400_it100.mat')
    data_nagib    = sio.loadmat('../output/CP_Win1-3-199_S1400_it100_PP_profile.mat')
    WS1 = data_nagib_gt['RetauGT'][0][0]*1.3/700
    W = data_nagib_gt['Win'][0,:] * WS1

    # Plot displacement thickness

    Figure03.plot_lines(
        W, 
        (data_nagib['med'][0,0][2][0,:] - data_nagib_gt['dsGT'][0,0]) / data_nagib_gt['dsGT'][0,0] * 100,
        0, 
        0, 
        linestyle=':',
        color=color_nagib
    )
    
    # Plot momentum thickness

    Figure03.plot_lines(
        W, 
        (data_nagib['med'][0,0][3][0,:] - data_nagib_gt['thetaGT'][0,0]) / data_nagib_gt['thetaGT'][0,0] * 100,
        1, 
        0, 
        linestyle=':',
        color=color_nagib
    )
    
    # Plot boundary layer thickness thickness

    Figure03.plot_lines(
        W, 
        (data_nagib['med'][0,0][4][0,:] - data_nagib_gt['D99GT'][0,0]) / data_nagib_gt['D99GT'][0,0] * 100,
        2, 
        0, 
        linestyle=':',
        color=color_nagib
    )
    
    # Plot friction velocty

    Figure03.plot_lines(
        W, 
        (data_nagib['med'][0,0][7][0,:] - data_nagib_gt['UTAUGT'][0,0]) / data_nagib_gt['UTAUGT'][0,0] * 100,
        0, 
        1, 
        linestyle=':',
        color=color_nagib
    )
    
    # Plot freestream velocity

    Figure03.plot_lines(
        W, 
        (data_nagib['med'][0,0][8][0,:] - data_nagib_gt['UINFGT'][0,0]) / data_nagib_gt['UINFGT'][0,0] * 100,
        1, 
        1, 
        linestyle=':',
        color=color_nagib
    )

    # Plot delta y

    Figure03.plot_lines(
        W, 
        (data_nagib['med'][0,0][10][0,:] - data_nagib_gt['DYwuGT'][0,0]),
        2, 
        1, 
        linestyle=':',
        color=color_nagib
    )


    """
        Renderize layout
    """
    # Assign text ticks to each panel
    Figure03.set_text('a) $\delta^*$', 0.075, 0.85, 0, 0)
    Figure03.set_text('b) $u_{\\tau}$', 0.075, 0.85, 0, 1)
    Figure03.set_text('c) $\\theta$', 0.075, 0.85, 1, 0)
    Figure03.set_text('d) $U_e$', 0.075, 0.85, 1, 1)
    Figure03.set_text('e) $\\delta$', 0.075, 0.85, 2, 0)
    Figure03.set_text('f) $\\Delta y^+_w$', 0.075, 0.85, 2, 1)

    # Assign labels to each panel
    Figure03.set_labels([None, "Error [\%]"], 0, 0, labelpad=[1, 4])
    Figure03.set_labels([None, "Error [\%]"], 1, 0, labelpad=[1, 2])
    Figure03.set_labels(["Bin size [$\ell^*$]", "Error [\%]"], 2, 0, labelpad=[1, 8])
    Figure03.set_labels([None, "Error [\%]"], 0, 1, labelpad=[1, -2])
    Figure03.set_labels([None, "Error [\%]"], 1, 1, labelpad=[1, -4])
    Figure03.set_labels(["Bin size [$\ell^*$]", "Error [$\Delta y^+$]"], 2, 1, labelpad=[1, -2])

    
    # Adjust tick labels for each panel
    Figure03.set_ticklabels([[],None], 0, 0)
    Figure03.set_ticklabels([[],None], 0, 1)
    Figure03.set_ticklabels([[],None], 1, 0)
    Figure03.set_ticklabels([[],None], 1, 1)
    Figure03.set_adjust(hspace=0.1)

    # Adjust axes lims for each panel
    Figure03.set_axis_lims([[0, 200],[-2,2]], 0, 0)
    Figure03.set_axis_lims([[0, 200],[-1,1]], 0, 1)
    Figure03.set_axis_lims([[0, 200],[-1,1]], 1, 0)
    Figure03.set_axis_lims([[0, 200],[-0.2,0.2]], 1, 1)
    Figure03.set_axis_lims([[0, 200],[-1,1]], 2, 0)
    Figure03.set_axis_lims([[0, 200],[-10,10]], 2, 1)
    
    # Adjust tick params
    Figure03.set_tick_params(0, 0, axis="both", direction="in", which="both", pad=4)
    Figure03.set_tick_params(1, 0, axis="both", direction="in", which="both", pad=4)
    Figure03.set_tick_params(2, 0, axis="both", direction="in", which="both", pad=4)
    Figure03.set_tick_params(0, 1, axis="both", direction="in", which="both", pad=4)
    Figure03.set_tick_params(1, 1, axis="both", direction="in", which="both", pad=4)
    Figure03.set_tick_params(2, 1, axis="both", direction="in", which="both", pad=4)
    
    # Save figure
    Figure03.save_figure("figs/figure03", fig_format='pdf')

    return


if __name__ == '__main__':
    
    main()