/*-------------------------------------------------------------------------
 *
 * merge_planner.h
 *	  Function declarations for building planned statements; these statements
 *	  are then executed on the coordinator node.
 *
 * Copyright (c) Citus Data, Inc.
 *
 *-------------------------------------------------------------------------
 */

#ifndef MERGE_PLANNER_H
#define MERGE_PLANNER_H

#include "lib/stringinfo.h"
#include "nodes/parsenodes.h"
#include "nodes/plannodes.h"

#if PG_VERSION_NUM >= PG_VERSION_12
#include "nodes/pathnodes.h"
#else
#include "nodes/relation.h"
#endif


/* Function declarations for building local plans on the master node */
struct DistributedPlan;
struct CustomScan;
extern Path * CreateCitusCustomScanPath(PlannerInfo *root, RelOptInfo *relOptInfo,
										Index restrictionIndex, RangeTblEntry *rte,
										CustomScan *remoteScan);
extern PlannedStmt * MasterNodeSelectPlan(struct DistributedPlan *distributedPlan,
										  struct CustomScan *dataScan);
extern Unique * make_unique_from_sortclauses(Plan *lefttree, List *distinctList);
extern bool ReplaceCitusExtraDataContainer;
extern CustomScan *ReplaceCitusExtraDataContainerWithCustomScan;

#endif   /* MERGE_PLANNER_H */
