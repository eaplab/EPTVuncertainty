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

    data_dns = sio.loadmat('../output/DNSprofileplot.mat')
   
    # Load experimental data with 50mm lens

    data_exp_50 = sio.loadmat('../output/ExpLens50mm.mat')
   
    # Load experimental data with 50mm lens

    data_exp_100 = sio.loadmat('../output/ExpLens100mm.mat')

    # Defining colors

    cmap = matplotlib.cm.get_cmap('inferno')
    color_dns        = cmap(0.2)
    color_eptv_50mm = cmap(0.4)
    color_eptv_100mm = cmap(0.8)

    """
        Generate figure
    """
    
    # Initialize plotting environment
    Figure05 = TheArtist()
    # Generate figure environment
    Figure05.generate_figure_environment(cols=2, rows=1, fig_width_pt=487.82, ratio='golden', regular=True)

    """
        Plot DNS data
    """
    
    Figure05.plot_lines_semi_x(data_dns['yp'], data_dns['Up'], 0, 0, color=color_dns, linewidth=1, linestyle='-', marker=None, markeredgecolor=None, markerfacecolor=None)
    Figure05.plot_lines_semi_x(data_dns['yp'], data_dns['u2p']**2, 0, 1, color=color_dns, linewidth=1, linestyle='-', marker=None, markeredgecolor=None, markerfacecolor=None)
    Figure05.plot_lines_semi_x(data_dns['yp'], data_dns['v2']**2, 0, 1, color=color_dns, linewidth=1, linestyle='-', marker=None, markeredgecolor=None, markerfacecolor=None)
    Figure05.plot_lines_semi_x(data_dns['yp'], data_dns['uv'], 0, 1, color=color_dns, linewidth=1, linestyle='-', marker=None, markeredgecolor=None, markerfacecolor=None)

    """
        Plot 100mm lens
    """
    
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_100['yp']), np.squeeze(data_exp_100['Up']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_eptv_100mm, markerfacecolor=(0,0,0,0))
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_100['yp']), np.squeeze(data_exp_100['u2p']**2), 0, 1, linestyle="None", marker='o', markeredgecolor=color_eptv_100mm, markerfacecolor=(0,0,0,0))
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_100['yp']), np.squeeze(data_exp_100['v2p']**2), 0, 1, linestyle="None", marker='s', markeredgecolor=color_eptv_100mm, markerfacecolor=(0,0,0,0))
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_100['yp']), -np.squeeze(data_exp_100['uvp']), 0, 1, linestyle="None", marker='^', markeredgecolor=color_eptv_100mm, markerfacecolor=(0,0,0,0))

    """
        Plot 50mm lens
    """
    
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_50['yp']), np.squeeze(data_exp_50['Up']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_eptv_50mm, markerfacecolor=(0,0,0,0))
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_50['yp']), np.squeeze(data_exp_50['u2p']**2), 0, 1, linestyle="None", marker='o', markeredgecolor=color_eptv_50mm, markerfacecolor=(0,0,0,0))
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_50['yp']), np.squeeze(data_exp_50['v2p']**2), 0, 1, linestyle="None", marker='s', markeredgecolor=color_eptv_50mm, markerfacecolor=(0,0,0,0))
    Figure05.plot_lines_semi_x(np.squeeze(data_exp_50['yp']), -np.squeeze(data_exp_50['uvp']), 0, 1, linestyle="None", marker='^', markeredgecolor=color_eptv_50mm, markerfacecolor=(0,0,0,0))
    

    """
        Renderize layout
    """
    # Assign text ticks to each panel
    Figure05.set_text('a)', 0.03, 0.9, 0, 0)
    Figure05.set_text('b)', 0.03, 0.9, 0, 1)

    # Assign labels to each panel
    Figure05.set_labels(["$y^+$", "$U^+$"], 0, 0, labelpad=[1, 0])
    Figure05.set_labels(["$y^+$", "$\\langle uu \\rangle ^+\\langle vv \\rangle ^+\\langle uv \\rangle ^+$"], 0, 1, labelpad=[1, 0])

    # Adjust axes lims for each panel
    Figure05.set_axis_lims([[1, 5000], [0, 30]], 0, 0)
    Figure05.set_axis_lims([[1, 5000], [-2, 10]], 0, 1)

    # Adjust tick params
    Figure05.set_tick_params(0, 0, axis="both", direction="in", which="both", pad=4)
    Figure05.set_tick_params(0, 1, axis="both", direction="in", which="both", pad=4)

    # Save figure
    Figure05.save_figure("figs/figure05", fig_format='pdf')

    return


if __name__ == '__main__':
    
    main()