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
import java.util.List;
import java.util.Map;
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
	private static List<Map<String, String>> csvrows = new ArrayList<Map<String,String>>();

	public static void main(String[] args)
			throws IOException, InterruptedException {
		initFreeMarkerConfiguration();
		buildAdditionalInfoFromCSV(args);
		writeTemplatedOutput(args[0]);
		logger.atInfo().log("Process %s.ftl to produce %s.jcl", args[0], args[0]);
	}

	private static void buildAdditionalInfoFromCSV(String[] args) throws IOException {
		if (args.length == 2) {
			String csvName = args[1];
			logger.atInfo().log("Reading csv information from %s", csvName);
			File csvFile = new File(csvName); // or from String, URL etc
			CsvMapper mapper = new CsvMapper();
			CsvSchema schema = CsvSchema.emptySchema().withHeader(); // use first row as header; otherwise defaults are
																		// fine
			MappingIterator<Map<String, String>> it = mapper.readerFor(Map.class)
					.with(schema)
					.readValues(csvFile);
			mapper.enable(CsvParser.Feature.WRAP_AS_ARRAY);
			while (it.hasNext()) {
				csvrows.add(it.next());
			}
		}
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

	private static Map<String, Object> buildTemplateModel(String name) {
		Map<String, Object> nodeMap = new HashMap<>();
		nodeMap.put("env", System.getenv());
		nodeMap.put("csvrows", csvrows);
		return nodeMap;
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

    public static void generateTestTemplatedOutput(Template temp, Map<String, Object> templateModel, Path target) throws IOException, TemplateException {
		logger.atInfo().log("Write to %s", target.toString());
        FileWriter cfgWriter = new FileWriter(target.toFile());
        temp.process(templateModel, cfgWriter);
        cfgWriter.close();
    }
}
