QUARTUS_ROOTDIR = getenv('QUARTUS_ROOTDIR');
quartus_bin = [QUARTUS_ROOTDIR filesep 'bin' filesep 'quartus'];

hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', quartus_bin);