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
   
    # Load experimental data
    data_02 = sio.loadmat('../output/ExpWin002.mat')
    data_04 = sio.loadmat('../output/ExpWin004.mat')
    data_08 = sio.loadmat('../output/ExpWin008.mat')
    data_16 = sio.loadmat('../output/ExpWin016.mat')
    data_32 = sio.loadmat('../output/ExpWin032.mat')
    data_64 = sio.loadmat('../output/ExpWin064.mat')


    # Defining colors

    cmap = matplotlib.cm.get_cmap('inferno')
    color_dns        = cmap(0.2)

    cmap = matplotlib.cm.get_cmap('Blues')
    color_02      = cmap(0.15)
    color_04      = cmap(0.3)
    color_08      = cmap(0.45)
    color_16      = cmap(0.6)
    color_32      = cmap(0.75)
    color_64      = cmap(0.9)

    """
        Generate figure
    """
    
    # Initialize plotting environment
    Figure02 = TheArtist()

    # Generate figure environment
    Figure02.generate_figure_environment(cols=1, rows=1, fig_width_pt=236.68, ratio='golden', regular=True)

    """
        Plot DNS data
    """
    
    Figure02.plot_lines_semi_x(data_dns['yp'], data_dns['Up'], 0, 0, color=color_dns, linewidth=1, linestyle='-', marker=None, markeredgecolor=None, markerfacecolor=None)

    """
        Plot 100mm lens
    """
    
    Figure02.plot_lines_semi_x(np.squeeze(data_02['ypiv']), np.squeeze(data_02['Upiv']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_02, markerfacecolor=(0,0,0,0))
    Figure02.plot_lines_semi_x(np.squeeze(data_04['ypiv']), np.squeeze(data_04['Upiv']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_04, markerfacecolor=(0,0,0,0))
    Figure02.plot_lines_semi_x(np.squeeze(data_08['ypiv']), np.squeeze(data_08['Upiv']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_08, markerfacecolor=(0,0,0,0))
    Figure02.plot_lines_semi_x(np.squeeze(data_16['ypiv']), np.squeeze(data_16['Upiv']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_16, markerfacecolor=(0,0,0,0))
    Figure02.plot_lines_semi_x(np.squeeze(data_32['ypiv']), np.squeeze(data_32['Upiv']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_32, markerfacecolor=(0,0,0,0))
    Figure02.plot_lines_semi_x(np.squeeze(data_64['ypiv']), np.squeeze(data_64['Upiv']), 0, 0, linestyle="None", marker='o', markeredgecolor=color_64, markerfacecolor=(0,0,0,0))


    """
        Renderize layout
    """

    # Assign labels to each panel
    Figure02.set_labels(["$y^+$", "$U^+$"], 0, 0, labelpad=[1, 0])

    # Adjust axes lims for each panel
    Figure02.set_axis_lims([[1, 5000], [0, 30]], 0, 0)

    # Adjust tick params
    Figure02.set_tick_params(0, 0, axis="both", direction="in", which="both", pad=4)

    # Save figure
    Figure02.save_figure("figs/figure02", fig_format='pdf')

    return


if __name__ == '__main__':
    
    main()