# Lab 4: Integrate Tableflow with AWS Glue Catalog and Query with Athena

This lab guides you through configuring AWS Glue Data Catalog as the external catalog for your Tableflow setup, and then querying the resulting Iceberg tables using AWS Athena. This allows the metadata of the Iceberg tables created by Tableflow in S3 to be automatically published to AWS Glue, making them easily queryable via standard SQL in Athena.

**Prerequisites:**

* You have completed **Lab 3: Configure AWS and Enable Tableflow**, meaning:
    * You have an S3 bucket configured.
    * You have a Provider Integration set up for S3 storage (`s3-provider-integration`) using an IAM role (`quickstart-tableflow-assume-role`).
    * Tableflow is enabled and syncing for one or more Kafka topics to your S3 bucket.
* Access to an AWS account with permissions to manage AWS Glue Data Catalog, AWS Athena, and create IAM policies and roles.
* Appropriate IAM permissions set up for Athena to query data in S3 and access the Glue Data Catalog.

---

## Step 1: Navigate to Tableflow Catalog Integration

1.  In your **Confluent Cloud** console, navigate to your Environment.
2.  Click on **Tableflow** in the left-hand menu.
3.  Scroll down to the **External Catalog Integration** section (or find a similar "Catalog Integration" area).

    `[Image Placeholder: Confluent Cloud Tableflow page showing the External Catalog Integration section]`

---

## Step 2: Start Adding Glue Integration

1.  Within the Catalog Integration section, click **+ Add Integration**.
2.  For the integration type, select **AWS Glue** as the catalog.
3.  Provide a **Name** for this specific catalog integration instance, for example, `my-glue-catalog-integration`.
4.  Click **Continue**. You will likely be prompted to configure a Provider Integration specifically for Glue access.

---

## Step 3: Create *New* Provider Integration for Glue Catalog Sync

**Important:** This creates a *separate* IAM Role and Provider Integration specifically for allowing Confluent Cloud to interact with your AWS Glue Data Catalog. It is *different* from the `s3-provider-integration` role used for writing data to S3.

1.  When prompted to configure the connection to Glue (likely within the "+ Add Integration" flow from Step 2, or you may need to navigate to Provider Integrations -> + Add Integration separately), choose to **create a new role**. Click **Continue**.
2.  On the "Create Permission Policy in AWS" screen, ensure the Confluent Resource selected is **Tableflow Glue Catalog sync** (or similar wording indicating Glue access, *not* S3 access).
3.  **IMPORTANT:** Confluent Cloud will display a JSON permissions policy specifically for Glue access. **Copy this `permissions-policy.json`**. You will need it in the next step. Keep this Confluent Cloud wizard page open.

    `[Image Placeholder: Confluent Cloud Provider Integration wizard showing Glue Catalog Sync selected and the specific permissions-policy.json for Glue]`

---

## Step 4: Create AWS IAM Policy for Glue Access

Use the policy JSON copied from the *Glue* wizard step to create an IAM policy in AWS.

1.  In your **AWS Management Console**, navigate to the **IAM** service.
2.  Click **Policies** -> **Create Policy**.
3.  Select the **JSON** tab.
4.  Paste the `permissions-policy.json` you copied in the previous step (specific to Glue access). *This policy likely grants permissions like `glue:GetDatabase`, `glue:CreateTable`, `glue:UpdateTable`, etc.*
5.  Click **Next** (or Next: Tags -> Next: Review).
6.  Give the policy a descriptive **Name**, like `tableflow-glue-access-policy`.
7.  Click **Create Policy**.

---

## Step 5: Create AWS IAM Role for Glue Access (Initial)

Create a new IAM role in AWS that Confluent Cloud will assume *specifically for Glue access*.

1.  Return to the **Confluent Cloud** wizard for the Glue Provider Integration. It should now display a **`trust-policy.json`** on the "Create role in AWS and map to Confluent" page. **Copy this `trust-policy.json`**. Keep the wizard open.
2.  In **AWS IAM**, navigate to **Roles** -> **Create role**.
3.  Select **Custom trust policy**.
4.  Paste the `trust-policy.json` you copied from the *Glue* Provider Integration wizard into the JSON editor.
5.  Click **Next**.
6.  On the **Add permissions** page, search for and select the IAM policy you created specifically for Glue access in Step 4 (e.g., `tableflow-glue-access-policy`).
7.  Click **Next**.
8.  Enter a **Role name** (distinct from your S3 role), e.g., `quickstart-tableflow-glue-assume-role`.
9.  Scroll down and click **Create role**.
10. After the role is created, view the role details and **copy its ARN**.

    `[Image Placeholder: AWS IAM role summary screen showing the ARN for the new Glue-specific role]`

---

## Step 6: Complete Glue Provider Integration (Confluent & AWS)

Link the new Glue IAM role back to Confluent Cloud.

1.  Return to the **Confluent Cloud** wizard for the Glue Provider Integration.
2.  Paste the **AWS Role ARN** for the *Glue access role* (copied in the previous step) into the appropriate field.
3.  Give this Glue-specific **Provider Integration** a **Name** (e.g., `glue-provider-integration`).
4.  Click **Continue**.
5.  **IMPORTANT:** Confluent Cloud will display an **updated Trust Policy JSON** (with the External ID) for the *Glue access role*. **Copy this entire updated `trust-policy.json`**.
6.  Go back to the **AWS IAM Role** you created specifically for Glue access (e.g., `quickstart-tableflow-glue-assume-role`).
7.  Select the **Trust relationships** tab and click **Edit trust policy**.
8.  **Replace the entire existing JSON** with the updated `trust-policy.json` (containing the External ID) you copied from Confluent Cloud.
9.  Click **Update policy**.
10. Return to the **Confluent Cloud** wizard and click **Continue** (or Finish/Create) to complete the Glue Provider Integration setup.

---

## Step 7: Finalize Catalog Integration Setup

Now, associate the Glue Provider Integration with the Catalog Integration configuration.

1.  You should be back in the **Catalog Integration** setup flow you started in Step 2 (where you named it `my-glue-catalog-integration`).
2.  In the section asking for the provider integration (or similar), select the **Glue Provider Integration** you just created (e.g., `glue-provider-integration`).
3.  Review the overall configuration for the AWS Glue Catalog Integration.
4.  Click **Launch** (or Continue/Create).

---

## Step 8: Verification (Glue Catalog)

1.  Monitor the status of the **Catalog Integration** (`my-glue-catalog-integration`) in the Confluent Cloud Tableflow UI. It should transition to **Connected** or **Running**.
2.  Navigate to the **AWS Glue Data Catalog** service in your AWS Console.
3.  Look for a new **Database** named after your Confluent Cloud Kafka Cluster ID (e.g., `lkc-xxxxxx`).
4.  Inside that database, you should start seeing **Tables** appearing with names corresponding to the Kafka topics you enabled Tableflow for in Lab 3 (e.g., `clicks`, `orders`).
5.  It might take a few minutes for the initial sync and table creation to occur.

---

## Step 9: Query Iceberg Tables with AWS Athena

Once the tables appear in AWS Glue, you can query them using Athena.

1.  **Navigate to Athena:**
    * In your **AWS Management Console**, navigate to the **Amazon Athena** service.
    * Ensure you are in the correct AWS region.

2.  **Configure Query Editor:**
    * In the Athena query editor, verify your **Workgroup** settings (the default `primary` workgroup is often sufficient, but ensure it has an S3 query result location configured).
    * For **Data source**, select **AwsDataCatalog**. This tells Athena to use your Glue Data Catalog.
    * For **Database**, select the database name that corresponds to your Kafka Cluster ID (e.g., `lkc-xxxxxx`), which you verified in Step 8.

    `[Image Placeholder: AWS Athena Query Editor showing AwsDataCatalog selected and the cluster-id database chosen]`

3.  **Run Queries:**
    * You can now run standard SQL queries against the tables registered in Glue. The table names will typically match your Kafka topic names.
    * **Example Queries:** Replace `<<your_kafka_cluster_id_database>>` with the actual Glue database name and `<<your_kafka_topic_table>>` with the actual Glue table name (e.g., `clicks`, `orders`).

      ```sql
      -- See the first 10 records from a table
      SELECT *
      FROM "<<your_kafka_cluster_id_database>>"."<<your_kafka_topic_table>>"
      LIMIT 10;

      -- Count the total number of records (will increase as Tableflow syncs)
      SELECT COUNT(*)
      FROM "<<your_kafka_cluster_id_database>>"."<<your_kafka_topic_table>>";

      -- Example: Count records for a specific condition (if applicable to your schema)
      -- SELECT COUNT(*)
      -- FROM "<<your_kafka_cluster_id_database>>"."orders"
      -- WHERE order_status = 'SHIPPED';
      ```
    * Type your query into the editor and click **Run**.

4.  **Analyze Results:**
    * The query results will appear in the **Results** pane below the editor.

**Important Note on Access Control:** As mentioned before, ensure the IAM principal (user or role) running Athena queries has read-only access to the Glue Data Catalog resources (database, tables) and the underlying S3 data location (`s3:GetObject` on `s3://<<Your S3 Bucket Name>>/*`). Avoid granting write permissions via Athena to data managed by Tableflow.

---

You have now successfully integrated Tableflow with your AWS Glue Data Catalog and queried the automatically created Iceberg tables using AWS Athena.