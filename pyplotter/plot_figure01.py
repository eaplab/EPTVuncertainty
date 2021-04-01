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
        Generate data
    """

    Win = np.arange(1,65)
    S = np.arange(500,4501,50)
    ww,ss = np.meshgrid(Win,S)
    wu = 1.3*1400*ww/ss

    """
        Generate figure
    """
    
    # Initialize plotting environment
    Figure01 = TheArtist()
    # Generate figure environment
    Figure01.generate_figure_environment(cols=1, rows=1, fig_width_pt=236.68, ratio='golden', regular=True)

    Figure01.plot_panel_contourf(
        ww, 
        ss/1400/1.3, 
        wu, 
        0, 
        0, 
        levels=np.linspace(0,200,11), 
        cmap='Greys', 
        clims=[0, 200]
    )

    """
        Renderize layout
    """

    # Assign labels to each panel
    Figure01.set_labels(["Bin size [Pix]", "Resolution [Pix/$\\ell^*$]"], 0, 0, labelpad=[1, 1])

    # Adjust axes lims for each panel
    Figure01.set_axis_lims([[1,64],[0.27,2.4]], 0, 0)

    # Adjust colorbar
    Figure01.set_colorbar(0, 0, 0, fraction=0.075, ticks=[0,40,80,120,160, 200])

    # Adjust tick params
    Figure01.set_tick_params(0, 0, axis="both", direction="in", which="both", pad=2)

    # Adjust ticks
    Figure01.set_ticks([range(4,61,8), None], 0, 0)

    # Save figure

    Figure01.save_figure("figs/figure01", fig_format='pdf')

    return


if __name__ == '__main__':
    
    main()