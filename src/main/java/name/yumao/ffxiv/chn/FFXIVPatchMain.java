package name.yumao.ffxiv.chn;

import java.io.File;
import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

import name.yumao.ffxiv.chn.swing.ConfigApplicationPanel;
import name.yumao.ffxiv.chn.swing.TextPatchPanel;
import name.yumao.ffxiv.chn.util.res.Config;

public class FFXIVPatchMain {
	public static void main(String[] args) {
		Config.setConfigResource("conf" + File.separator + "global.properties");
		String path = Config.getProperty("GamePath");
		
		// logger setup
		Logger log = Logger.getLogger("GPLogger");
		SimpleFormatter formatter = new SimpleFormatter() {
		    private static final String format = "[%1$tF %1$tT] [%4$-7s] %2$s%5$s%6$s%n";

		    @Override
		    public synchronized String format(java.util.logging.LogRecord record) {
		        return String.format(format,
		                new java.util.Date(record.getMillis()),
		                record.getMessage(),
		                record.getSourceClassName(),
		                record.getLevel().getLocalizedName(),
		                record.getThrown() != null ? record.getThrown().getMessage() + System.lineSeparator() : "",
		                getStackTrace(record.getThrown()));
		    }

		    private String getStackTrace(Throwable throwable) {
		        if (throwable == null) {
		            return "";
		        }

		        java.io.StringWriter sw = new java.io.StringWriter();
		        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
		        throwable.printStackTrace(pw);
		        return sw.toString();
		    }
		};
		log.setUseParentHandlers(false);
		log.setLevel(Level.ALL);
		try {
			FileHandler fh = new FileHandler("debug.log");
			fh.setEncoding("UTF-8");
			log.addHandler(fh);
	        fh.setFormatter(formatter);  
		} catch (IOException e) {  
	        e.printStackTrace();  
	    }
		log.config("Java Version: " + System.getProperty("java.runtime.version"));
		
		if (isFFXIVFloder(path)) {
			new TextPatchPanel();
		} else {
			new ConfigApplicationPanel();
		} 
	}
	
	private static boolean isFFXIVFloder(String path) {
		if (path == null)
			return false; 
		return (new File(path + File.separator + "game" + File.separator + "ffxiv_dx11.exe")).exists();
	}
}
