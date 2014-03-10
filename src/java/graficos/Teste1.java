package graficos;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.Date;
import java.util.Map;
import de.laures.cewolf.DatasetProduceException;
import de.laures.cewolf.DatasetProducer;
import de.laures.cewolf.links.CategoryItemLinkGenerator;
import de.laures.cewolf.tooltips.CategoryToolTipGenerator;
import ja_jdbc_plpgsql.bean.bConsulta2;
import ja_jdbc_plpgsql.jdbc.jConsultaWeb;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

public class Teste1 implements DatasetProducer, CategoryToolTipGenerator, CategoryItemLinkGenerator, Serializable {

    private final String categories[] = {"legal"};
    private final ArrayList<String> seriesNames = null;

    @Override
    public Object produceDataset(Map params) throws DatasetProduceException {

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        try {
            ArrayList<bConsulta2> obja = jConsultaWeb.getMediaHoras2(
                    params.get("data_in").toString(),
                    params.get("data_fim").toString(),
                    Integer.valueOf(params.get("gmp").toString()),
                    params.get("arg_prod").toString());

/*
            for (int series = 0; series < seriesNames.length; series++) {
                int lastY = (int) (Math.random() * 1000D + 1000D);
                for (int i = 0; i < categories.length; i++) {
                    int y = lastY + (int) (Math.random() * 200D - 100D);
                    lastY = y;
                    dataset.addValue(y, seriesNames[series], categories[i]);
                }
            }
*/
            for (bConsulta2 a : obja) {
                
                dataset.addValue(a.getCont(),a.getPosto() , a.getData_in());
                //seriesNames.add(a.getPosto().toString());
                
            }

        } catch (SQLException ex) {
            Logger.getLogger(Teste1.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Teste1.class.getName()).log(Level.SEVERE, null, ex);
        }
        return dataset;
    }

    @Override
    public boolean hasExpired(Map params, Date since) {
        return System.currentTimeMillis() - since.getTime() > 0L;
    }

    @Override
    public String getProducerId() {
        return "PageViewCountData DatasetProducer";
    }

    @Override
    public String generateLink(Object data, int series, Object category) {
        return seriesNames.get(series);
    }

    @Override
    public String generateToolTip(CategoryDataset arg0, int series, int arg2) {
        return seriesNames.get(series);
    }
}
