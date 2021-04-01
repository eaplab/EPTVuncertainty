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

    data_dns_gt = sio.loadmat('../output/DNSTorroja_ReTh4500-GT.mat')
    data_dns    = sio.loadmat('../output/DNS_Win1-1-32_S700_it2000_PP_profile.mat')
    WS1 = list(data_dns['Win'][0] * data_dns_gt['RetauGT'][0] * 1.3 / 700)
   
    # Load Nagib data

    data_nagib = sio.loadmat('../output/CP_Win1-1-32_S700_it2000_PP_profile.mat')
    data_nagib_gt = sio.loadmat('../output/Nagib_Retau1400-GT.mat')
    WS2 = list(data_nagib['Win'][0] * data_nagib_gt['RetauGT'][0] * 1.3 / 700)
   
    # Load experimental data

    data_exp = sio.loadmat('../output/EPTV_experiments_2000.mat')
    data_exp_gt = sio.loadmat('../output/EPTV_experiments_28000.mat')
   
    ref_exp = 1

    # Defining colors

    cmap = matplotlib.cm.get_cmap('inferno')
    color_dns        = cmap(0.2)
    color_nagib      = cmap(0.6)
    color_eptv_050mm = cmap(0.4)
    color_eptv_100mm = cmap(0.8)

    """
        Generate figure
    """
    
    # Initialize plotting environment
    Figure06 = TheArtist()

    # Generate figure environment
    Figure06.generate_figure_environment(cols=2, rows=3, fig_width_pt=487.82, ratio='golden', regular=True)

    """
        Plot Nagib data
    """
    
    # Plot displacement thickness
    med = list(((data_nagib['med'][0,0][2] - data_nagib_gt['dsGT'][0,0]) / data_nagib_gt['dsGT'][0,0] * 100)[0])
    up = list(((data_nagib['med'][0,0][2] - data_nagib_gt['dsGT'][0,0] + 3 * np.abs(data_nagib['sigma'][0,0][2])) / data_nagib_gt['dsGT'][0,0] * 100)[0])
    do = list(((data_nagib['med'][0,0][2] - data_nagib_gt['dsGT'][0,0] - 3 * np.abs(data_nagib['sigma'][0,0][2])) / data_nagib_gt['dsGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS2, up)] + [[x,y] for x,y in zip(WS2[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 0, 0, alpha=0.3, edgecolor=color_nagib, facecolor=color_nagib)
    Figure06.plot_lines(WS2, med, 0, 0, linestyle='--', color=color_nagib)

    # Plot momentum thickness
    med = list(((data_nagib['med'][0,0][3] - data_nagib_gt['thetaGT'][0,0]) / data_nagib_gt['thetaGT'][0,0] * 100)[0])
    up = list(((data_nagib['med'][0,0][3] - data_nagib_gt['thetaGT'][0,0] + 3 * np.abs(data_nagib['sigma'][0,0][3])) / data_nagib_gt['thetaGT'][0,0] * 100)[0])
    do = list(((data_nagib['med'][0,0][3] - data_nagib_gt['thetaGT'][0,0] - 3 * np.abs(data_nagib['sigma'][0,0][3])) / data_nagib_gt['thetaGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS2, up)] + [[x,y] for x,y in zip(WS2[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 1, 0, alpha=0.3, edgecolor=color_nagib, facecolor=color_nagib)
    Figure06.plot_lines(WS2, med, 1, 0, linestyle='--', color=color_nagib)

    # Plot boundary layer thickness thickness
    med = list(((data_nagib['med'][0,0][4] - data_nagib_gt['D99GT'][0,0]) / data_nagib_gt['D99GT'][0,0] * 100)[0])
    up = list(((data_nagib['med'][0,0][4] - data_nagib_gt['D99GT'][0,0] + 3 * np.abs(data_nagib['sigma'][0,0][4])) / data_nagib_gt['D99GT'][0,0] * 100)[0])
    do = list(((data_nagib['med'][0,0][4] - data_nagib_gt['D99GT'][0,0] - 3 * np.abs(data_nagib['sigma'][0,0][4])) / data_nagib_gt['D99GT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS2, up)] + [[x,y] for x,y in zip(WS2[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 2, 0, alpha=0.3, edgecolor=color_nagib, facecolor=color_nagib)
    Figure06.plot_lines(WS2, med, 2, 0, linestyle='--', color=color_nagib)
    
    # Plot friction velocty
    med = list(((data_nagib['med'][0,0][7] - data_nagib_gt['UTAUGT'][0,0]) / data_nagib_gt['UTAUGT'][0,0] * 100)[0])
    up = list(((data_nagib['med'][0,0][7] - data_nagib_gt['UTAUGT'][0,0] + 3 * np.abs(data_nagib['sigma'][0,0][7])) / data_nagib_gt['UTAUGT'][0,0] * 100)[0])
    do = list(((data_nagib['med'][0,0][7] - data_nagib_gt['UTAUGT'][0,0] - 3 * np.abs(data_nagib['sigma'][0,0][7])) / data_nagib_gt['UTAUGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS2, up)] + [[x,y] for x,y in zip(WS2[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 0, 1, alpha=0.3, edgecolor=color_nagib, facecolor=color_nagib)
    Figure06.plot_lines(WS2, med, 0, 1, linestyle='--', color=color_nagib)
    
    # Plot freestream velocity
    med = list(((data_nagib['med'][0,0][8] - data_nagib_gt['UINFGT'][0,0]) / data_nagib_gt['UINFGT'][0,0] * 100)[0])
    up = list(((data_nagib['med'][0,0][8] - data_nagib_gt['UINFGT'][0,0] + 3 * np.abs(data_nagib['sigma'][0,0][8])) / data_nagib_gt['UINFGT'][0,0] * 100)[0])
    do = list(((data_nagib['med'][0,0][8] - data_nagib_gt['UINFGT'][0,0] - 3 * np.abs(data_nagib['sigma'][0,0][8])) / data_nagib_gt['UINFGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS2, up)] + [[x,y] for x,y in zip(WS2[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 1, 1, alpha=0.3, edgecolor=color_nagib, facecolor=color_nagib)
    Figure06.plot_lines(WS2, med, 1, 1, linestyle='--', color=color_nagib)
    
    # Plot delta y
    med = list(((data_nagib['med'][0,0][10] - data_nagib_gt['DYwuGT'][0,0]))[0])
    up = list(((data_nagib['med'][0,0][10] - data_nagib_gt['DYwuGT'][0,0] + 3 * np.abs(data_nagib['sigma'][0,0][10])))[0])
    do = list(((data_nagib['med'][0,0][10] - data_nagib_gt['DYwuGT'][0,0] - 3 * np.abs(data_nagib['sigma'][0,0][10])))[0])
    polygon = [[x,y] for x,y in zip(WS2, up)] + [[x,y] for x,y in zip(WS2[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 2, 1, alpha=0.3, edgecolor=color_nagib, facecolor=color_nagib)
    Figure06.plot_lines(WS2, med, 2, 1, linestyle='--', color=color_nagib)

    """
        Plot DNS data
    """
    
    # Plot displacement thickness

    med = list(((data_dns['med'][0,0][2] - data_dns_gt['dsGT'][0,0]) / data_dns_gt['dsGT'][0,0] * 100)[0])
    up = list(((data_dns['med'][0,0][2] - data_dns_gt['dsGT'][0,0] + 3 * np.abs(data_dns['sigma'][0,0][2])) / data_dns_gt['dsGT'][0,0] * 100)[0])
    do = list(((data_dns['med'][0,0][2] - data_dns_gt['dsGT'][0,0] - 3 * np.abs(data_dns['sigma'][0,0][2])) / data_dns_gt['dsGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS1, up)] + [[x,y] for x,y in zip(WS1[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 0, 0, alpha=0.3, edgecolor=color_dns, facecolor=color_dns)
    Figure06.plot_lines(WS1, med, 0, 0, linestyle='-', color=color_dns)
    
    # Plot momentum thickness
    med = list(((data_dns['med'][0,0][3] - data_dns_gt['thetaGT'][0,0]) / data_dns_gt['thetaGT'][0,0] * 100)[0])
    up = list(((data_dns['med'][0,0][3] - data_dns_gt['thetaGT'][0,0] + 3 * np.abs(data_dns['sigma'][0,0][3])) / data_dns_gt['thetaGT'][0,0] * 100)[0])
    do = list(((data_dns['med'][0,0][3] - data_dns_gt['thetaGT'][0,0] - 3 * np.abs(data_dns['sigma'][0,0][3])) / data_dns_gt['thetaGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS1, up)] + [[x,y] for x,y in zip(WS1[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 1, 0, alpha=0.3, edgecolor=color_dns, facecolor=color_dns)
    Figure06.plot_lines(WS1, med, 1, 0, linestyle='-', color=color_dns)

    # Plot boundary layer thickness thickness
    med = list(((data_dns['med'][0,0][4] - data_dns_gt['D99GT'][0,0]) / data_dns_gt['D99GT'][0,0] * 100)[0])
    up = list(((data_dns['med'][0,0][4] - data_dns_gt['D99GT'][0,0] + 3 * np.abs(data_dns['sigma'][0,0][4])) / data_dns_gt['D99GT'][0,0] * 100)[0])
    do = list(((data_dns['med'][0,0][4] - data_dns_gt['D99GT'][0,0] - 3 * np.abs(data_dns['sigma'][0,0][4])) / data_dns_gt['D99GT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS1, up)] + [[x,y] for x,y in zip(WS1[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 2, 0, alpha=0.3, edgecolor=color_dns, facecolor=color_dns)
    Figure06.plot_lines(WS1, med, 2, 0, linestyle='-', color=color_dns)
    
    # Plot friction velocty
    med = list(((data_dns['med'][0,0][7] - data_dns_gt['UTAUGT'][0,0]) / data_dns_gt['UTAUGT'][0,0] * 100)[0])
    up = list(((data_dns['med'][0,0][7] - data_dns_gt['UTAUGT'][0,0] + 3 * np.abs(data_dns['sigma'][0,0][7])) / data_dns_gt['UTAUGT'][0,0] * 100)[0])
    do = list(((data_dns['med'][0,0][7] - data_dns_gt['UTAUGT'][0,0] - 3 * np.abs(data_dns['sigma'][0,0][7])) / data_dns_gt['UTAUGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS1, up)] + [[x,y] for x,y in zip(WS1[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 0, 1, alpha=0.3, edgecolor=color_dns, facecolor=color_dns)
    Figure06.plot_lines(WS1, med, 0, 1, linestyle='-', color=color_dns)
    
    # Plot freestream velocity
    med = list(((data_dns['med'][0,0][8] - data_dns_gt['UINFGT'][0,0]) / data_dns_gt['UINFGT'][0,0] * 100)[0])
    up = list(((data_dns['med'][0,0][8] - data_dns_gt['UINFGT'][0,0] + 3 * np.abs(data_dns['sigma'][0,0][8])) / data_dns_gt['UINFGT'][0,0] * 100)[0])
    do = list(((data_dns['med'][0,0][8] - data_dns_gt['UINFGT'][0,0] - 3 * np.abs(data_dns['sigma'][0,0][8])) / data_dns_gt['UINFGT'][0,0] * 100)[0])
    polygon = [[x,y] for x,y in zip(WS1, up)] + [[x,y] for x,y in zip(WS1[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 1, 1, alpha=0.3, edgecolor=color_dns, facecolor=color_dns)
    Figure06.plot_lines(WS1, med, 1, 1, linestyle='-', color=color_dns)
    
    # Plot delta y
    med = list(((data_dns['med'][0,0][10] - data_dns_gt['DYwuGT'][0,0]))[0])
    up = list(((data_dns['med'][0,0][10] - data_dns_gt['DYwuGT'][0,0] + 3 * np.abs(data_dns['sigma'][0,0][10])))[0])
    do = list(((data_dns['med'][0,0][10] - data_dns_gt['DYwuGT'][0,0] - 3 * np.abs(data_dns['sigma'][0,0][10])))[0])
    polygon = [[x,y] for x,y in zip(WS1, up)] + [[x,y] for x,y in zip(WS1[::-1], do[::-1])]
    Figure06.plot_patch(polygon, 2, 1, alpha=0.3, edgecolor=color_dns, facecolor=color_dns)
    Figure06.plot_lines(WS1, med, 2, 1, linestyle='-', color=color_dns)

    
 
    """
        Plot experimental data with 50mm lens
    """
    
    # Plot displacement thickness
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS1'], (data_exp['DS'] - data_exp_gt['DS'][0, ref_exp]) / data_exp_gt['DS'][0, ref_exp] * 100, 0, 0, 
        linestyle=None, 
        marker='s', 
        markeredgecolor=color_eptv_050mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot momentum thickness
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS1'], (data_exp['THETA'] - data_exp_gt['THETA'][0, ref_exp]) / data_exp_gt['THETA'][0, ref_exp] * 100, 1, 0, 
        linestyle=None, 
        marker='s', 
        markeredgecolor=color_eptv_050mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot boundary layer thickness thickness
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS1'], (data_exp['D99_N'] - data_exp_gt['D99_N'][0, ref_exp]) / data_exp_gt['D99_N'][0, ref_exp] * 100, 2, 0, 
        linestyle=None, 
        marker='s', 
        markeredgecolor=color_eptv_050mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot friction velocty
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS1'], (data_exp['UTAU'] - data_exp_gt['UTAU'][0, ref_exp]) / data_exp_gt['UTAU'][0, ref_exp] * 100, 0, 1, 
        linestyle=None, 
        marker='s', 
        markeredgecolor=color_eptv_050mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot freestream velocity
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS1'], (data_exp['UINF'] - data_exp_gt['UINF'][0, ref_exp]) / data_exp_gt['UINF'][0, ref_exp] * 100, 1, 1, 
        linestyle=None, 
        marker='s', 
        markeredgecolor=color_eptv_050mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot delta y
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS1'], (data_exp['DYwu'] - data_exp_gt['DYwu'][0, ref_exp]), 
        2, 
        1, 
        linestyle=None, 
        marker='s', 
        markeredgecolor=color_eptv_050mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )

    """
        Plot experimental data with 100mm lens
    """
    
    # Plot displacement thickness
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS2'], (data_exp['DS100'] - data_exp_gt['DS100'][0, ref_exp]) / data_exp_gt['DS100'][0, ref_exp] * 100, 0, 0, 
        linestyle=None, 
        marker='o', 
        markeredgecolor=color_eptv_100mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot momentum thickness
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS2'], (data_exp['THETA100'] - data_exp_gt['THETA100'][0, ref_exp]) / data_exp_gt['THETA100'][0, ref_exp] * 100, 1, 0, 
        linestyle=None, 
        marker='o', 
        markeredgecolor=color_eptv_100mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot boundary layer thickness thickness
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS2'], (data_exp['D99_N100'] - data_exp_gt['D99_N100'][0, ref_exp]) / data_exp_gt['D99_N100'][0, ref_exp] * 100, 2, 0, 
        linestyle=None, 
        marker='o', 
        markeredgecolor=color_eptv_100mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot friction velocty
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS2'], (data_exp['UTAU100'] - data_exp_gt['UTAU100'][0, ref_exp]) / data_exp_gt['UTAU100'][0, ref_exp] * 100, 0, 1, 
        linestyle=None, 
        marker='o', 
        markeredgecolor=color_eptv_100mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot freestream velocity
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS2'], (data_exp['UINF100'] - data_exp_gt['UINF100'][0, ref_exp]) / data_exp_gt['UINF100'][0, ref_exp] * 100, 1, 1, 
        linestyle=None, 
        marker='o', 
        markeredgecolor=color_eptv_100mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )
    
    # Plot delta y
    Figure06.plot_lines(data_exp['Win'] / data_exp['WS2'], (data_exp['DYwu100'] - data_exp_gt['DYwu100'][0, ref_exp]), 2, 1, 
        linestyle=None, 
        marker='o', 
        markeredgecolor=color_eptv_100mm, 
        markerfacecolor=(1,1,1,0), 
        markersize=2
    )

    """
        Renderize layout
    """
    # Assign text ticks to each panel
    Figure06.set_text('a) $\\delta^*$', 0.075, 0.85, 0, 0)
    Figure06.set_text('b) $u_{\\tau}$', 0.075, 0.85, 0, 1)
    Figure06.set_text('c) $\\theta$', 0.075, 0.85, 1, 0)
    Figure06.set_text('d) $U_e$', 0.075, 0.85, 1, 1)
    Figure06.set_text('e) $\\delta$', 0.075, 0.85, 2, 0)
    Figure06.set_text('f) $\\Delta y^+_w$', 0.075, 0.85, 2, 1)

    # Assign labels to each panel
    Figure06.set_labels([None, "Error [\\%]"], 0, 0, labelpad=[1, -2])
    Figure06.set_labels([None, "Error [\\%]"], 1, 0, labelpad=[1, -2])
    Figure06.set_labels(["Bin size [$\\ell^*$]", "Error [\\%]"], 2, 0, labelpad=[1, -2])
    Figure06.set_labels([None, "Error [\\%]"], 0, 1, labelpad=[1, -2])
    Figure06.set_labels([None, "Error [\\%]"], 1, 1, labelpad=[1, -4])
    Figure06.set_labels(["Bin size [$\\ell^*$]", "Error [$\\Delta y^+$]"], 2, 1, labelpad=[1, -2])

    # Adjust axes lims for each panel
    Figure06.set_axis_lims([[0, 60], [-4, 4]], 0, 0)
    Figure06.set_axis_lims([[0, 60], [-4, 4]], 1, 0)
    Figure06.set_axis_lims([[0, 60], [-4, 4]], 2, 0)
    Figure06.set_axis_lims([[0, 60], [-2, 2]], 0, 1)
    Figure06.set_axis_lims([[0, 60], [-0.4, 0.4]], 1, 1)
    Figure06.set_axis_lims([[0, 60], [-14, 14]], 2, 1)

    # Adjust ticks
    Figure06.set_ticks([None, [-14, -7, 0, 7, 14]], 2, 1)

    #Adjust tick params
    Figure06.set_tick_params(0, 0, axis="both", direction="in", which="both", pad=4)
    Figure06.set_tick_params(1, 0, axis="both", direction="in", which="both", pad=4)
    Figure06.set_tick_params(2, 0, axis="both", direction="in", which="both", pad=4)
    Figure06.set_tick_params(0, 1, axis="both", direction="in", which="both", pad=4)
    Figure06.set_tick_params(1, 1, axis="both", direction="in", which="both", pad=4)
    Figure06.set_tick_params(2, 1, axis="both", direction="in", which="both", pad=4)

    # Adjust tick labels
    Figure06.set_ticklabels([[],None], 0, 0)
    Figure06.set_ticklabels([[],None], 0, 1)
    Figure06.set_ticklabels([[],None], 1, 0)
    Figure06.set_ticklabels([[],None], 1, 1)
    Figure06.set_adjust(hspace=0.1)
    
    # Save figure
    Figure06.save_figure("figs/figure06", fig_format='pdf')

    return


if __name__ == '__main__':
    
    main()