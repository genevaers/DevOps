package org.genevaers.ftl2jcl;

import java.io.File;
import java.io.FileWriter;

/*
 * Copyright Contributors to the GenevaERS Project. SPDX-License-Identifier: Apache-2.0 (c) Copyright IBM Corporation 2008
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvParser;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;
import com.google.common.flogger.FluentLogger;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;

public class CommandLineHandler {
	private static final FluentLogger logger = FluentLogger.forEnclosingClass();
	private static Configuration cfg;
	private static List<Map<String, String>> tables = new ArrayList<Map<String, String>>();
	private static Path parent;

	public static void main(String[] args)
			throws IOException, InterruptedException {
		initFreeMarkerConfiguration();
		buildAdditionalInfoFromCSV(args);
		writeTemplatedOutput(args[0]);
		logger.atInfo().log("Process %s.ftl to produce %s.jcl", args[0], args[0]);
	}

	private static void buildAdditionalInfoFromCSV(String[] args) throws IOException {
		if (args.length == 2) {
			Path tablesPath = Paths.get(args[1] + ".csv");
			logger.atInfo().log("Reading tables information from %s", tablesPath);
			fillTableFromCsv(tablesPath, tables);
		}
	}

	private static void fillTableFromCsv(Path csvPath, List<Map<String, String>> table) throws IOException {
		parent = csvPath.getParent();

		logger.atInfo().log("Reading from %s", csvPath);
		CsvMapper mapper = new CsvMapper();
		CsvSchema schema = CsvSchema.emptySchema().withHeader(); // use first row as header
		MappingIterator<Map<String, String>> it = mapper.readerFor(Map.class)
				.with(schema)
				.readValues(csvPath.toFile());
		mapper.enable(CsvParser.Feature.WRAP_AS_ARRAY);
		while (it.hasNext()) {
			// Map<String, String> entry = it.next();
			// for (Entry<String, String> e : entry.entrySet()) {
			// 	Map<String, String> tablePath = new HashMap<String, String>();
			// 	tablePath.put(e.getKey(), e.getValue());
				table.add(it.next());
			//}
		}
		return;
	}

	private static void writeTemplatedOutput(String name) {
		try {
			String targetStr = name + ".jcl";
			Template template = cfg.getTemplate(name + ".ftl");
			generateTestTemplatedOutput(template, buildTemplateModel(name), Paths.get(targetStr));
		} catch (IOException | TemplateException e) {
			logger.atSevere().log("Template generation failed.\n %s", e.getMessage());
		}
	}

	private static Map<String, Object> buildTemplateModel(String name) throws IOException {
		Iterator<Map<String, String>> tablesIt = tables.iterator();
		Map<String, Object> nodeMap = new HashMap<>();
		nodeMap.put("env", System.getenv());
		while (tablesIt.hasNext()) {
			Map<String, String> mytables = tablesIt.next(); // first is the header
			Iterator<String> tableNamesIt = mytables.values().iterator();
			while (tableNamesIt.hasNext()) {
				String tableName = tableNamesIt.next();
				addTableToTemplateMap(tableName, nodeMap);
			}
		}
		return nodeMap;
	}

	private static void addTableToTemplateMap(String tableName, Map<String, Object> nodeMap) throws IOException {
		List<Map<String, String>> namedTableRows = new ArrayList<Map<String, String>>();
		fillTableFromCsv(parent.resolve(tableName + ".csv"), namedTableRows);
		nodeMap.put(tableName, namedTableRows);
	}

	public static String readVersion() {
		String version = "unknown";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties properties = new Properties();
		try (InputStream resourceStream = loader.getResourceAsStream("application.properties")) {
			properties.load(resourceStream);
			version = properties.getProperty("build.version") + " (" + properties.getProperty("build.timestamp") + ")";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return version;
	}

	private static void initFreeMarkerConfiguration() throws IOException {
		cfg = new Configuration(Configuration.VERSION_2_3_30);
		cfg.setDirectoryForTemplateLoading(new File("./"));
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
	}

	public static void generateTestTemplatedOutput(Template temp, Map<String, Object> templateModel, Path target)
			throws IOException, TemplateException {
		logger.atInfo().log("Write to %s", target.toString());
		FileWriter cfgWriter = new FileWriter(target.toFile());
		temp.process(templateModel, cfgWriter);
		cfgWriter.close();
	}

	public static String removeFileExtension(String filename, boolean removeAllExtensions) {
		if (filename == null || filename.isEmpty()) {
			return filename;
		}

		String extPattern = "(?<!^)[.]" + (removeAllExtensions ? ".*" : "[^.]*$");
		return filename.replaceAll(extPattern, "");
	}

}
