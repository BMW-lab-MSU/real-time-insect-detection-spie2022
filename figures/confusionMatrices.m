datadir = "../../../data/insect-lidar";

ogResults = load(datadir + filesep + "testing" + filesep + "results");
newResults = load(datadir + filesep + "codegen-testing" + filesep + "results");

%% Row-based confusion matrices
classNames = ["Non-insect", "Insect"];

confusionFig = figure('Units', 'Inches', 'Position', [2 2 6 2.5]);

confusion = tiledlayout(confusionFig, 1, 2);

nexttile
ogConfusion = confusionchart(ogResults.nnet.Row.Confusion, classNames);
sortClasses(ogConfusion, classNames);
ogConfusion.FontSize = 11;
ogConfusion.XLabel = '';
ogConfusion.YLabel = '';
ogConfusion.Title = 'Original Software';
set(gca, 'FontName', 'CMU Serif')


nexttile
newConfusion = confusionchart(newResults.nnet.Row.Confusion, classNames);
sortClasses(newConfusion, classNames);
newConfusion.FontSize = 11;
newConfusion.XLabel = '';
newConfusion.YLabel = '';
newConfusion.Title = 'New Software';

confusion.XLabel.String = 'Predicted class';
confusion.YLabel.String = 'Human-labeled class';
confusion.XLabel.FontSize = 11;
confusion.YLabel.FontSize = 11;
set(gca, 'FontName', 'CMU Serif')

confusion.Padding = 'tight';
% confusion.TileSpacing = 'tight';
confusion.XLabel.FontName = 'CMU Serif';
confusion.YLabel.FontName = 'CMU Serif';


exportgraphics(confusionFig, 'confusion.pdf', 'ContentType', 'vector')